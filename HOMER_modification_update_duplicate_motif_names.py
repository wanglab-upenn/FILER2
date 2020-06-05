## Add a suffix into motifs which have an identical name, and export an updated PWM file

import gzip
import re
import sys
import math
from decimal import Decimal ## To get a precise float
from tqdm import tqdm

row_homer_bed_path = '/mnt/data/cylee/homer.KnownMotifs.hg38.170917.sorted.0-base.seq.bed.gz'
updated_homer_bed_path = '/mnt/data/cylee/homer.KnownMotifs.hg38.170917.sorted.0-base.seq.nameUpdated.bed.gz'
motif_pwm_path = '/home/cylee/spark-gadb/src/sparkgdm/data/known.motifs.homer.v4.10.3.txt'
updated_motif_pwm_path = '/mnt/data/cylee/known.motifs.homer.v4.10.3.updated.txt'
suffix = '-PWM-'
skipped_error_line = True

need_change_names_by_scoring = ['FOXA1(Forkhead)', 'Nr5a2(NR)', 'p53(p53)', 'RORgt(NR)']
need_change_names_by_length = ['c-Myc(bHLH)', 'COUP-TFII(NR)', 'RAR:RXR(NR),DR5', 'GRE(NR),IR3', 'HRE(HSF)', 'OCT:OCT(POU,Homeobox)', 'STAT6(Stat)', 'THRb(NR)']


## Read PWM score as a dictionary
def convert_pwm2dict(motif_pwm_file, new_motif_pwm_file):
    pwm_dict = {}
    with open(motif_pwm_file, 'r') as motif_pwms, open(new_motif_pwm_file, 'w') as new_motif_pwms:
        ## store the TF and PWM that we build up
        this_tf = ""
        this_pwm = []
        this_pwm_str = ""
        prior_line = ""
        for line in motif_pwms:
            line_data = line.strip().split("\t")
            updated_motif_name = ''
            if line[0]==">":
                ## if we have been building up a PWM, store it
                if this_tf:
                    if this_tf not in pwm_dict:
                        ## store it in a list so that we can add others
                        pwm_dict[this_tf] = [this_pwm]
                        
                        ## For updated motif PWM file
                        if this_tf in need_change_names_by_scoring+need_change_names_by_length:
                            updated_motif_name = this_tf + suffix + '1'
                        else:
                            updated_motif_name = this_tf
                        
                    else:
                        pwm_dict[this_tf].append(this_pwm)
                        
                        updated_motif_name = this_tf + suffix + str(len(pwm_dict[this_tf]))
                    
                    ## Write PWM info to the updated file
                    new_motif_pwms.write('%s%s' % (prior_line.replace(this_tf, updated_motif_name, 1), this_pwm_str))
                    
                ## reset the tracking variables
                this_tf = line_data[1].split("/")[0]
                this_pwm = []
                this_pwm_str = ""
                prior_line = line
            else:
                ## add this PWM info to the list
                this_pwm.append([float(x) for x in line_data])
                this_pwm_str += line
                
        ## store the last PWM
        if this_tf not in pwm_dict:
            pwm_dict[this_tf] = [this_pwm]
            
            if this_tf in need_change_names_by_scoring + need_change_names_by_length:
                updated_motif_name = this_tf + suffix + '1'
            else:
                updated_motif_name = this_tf
        else:
            pwm_dict[this_tf].append(this_pwm)
            
            updated_motif_name = this_tf + suffix + str(len(pwm_dict[this_tf]))
            
        new_motif_pwms.write('%s%s' % (prior_line.replace(this_tf, updated_motif_name, 1), this_pwm_str))
        
    ## The final structure of the returned pwm_dict would look like as:
    ## {'FOXA1(FORKHEAD)': [[0.483, 0.026, 0.01, 0.481],
    ##                       ...
    ##                      [0.997, 0.001, 0.001, 0.001]],
    ##                     [[0.498, 0.005, 0.001, 0.496],
    ##                       ...
    ##                      [0.997, 0.001, 0.001, 0.001]],
    ##       'ZNF711(ZF)': [[0.588, 0.22, 0.13, 0.063],
    ##                       ...
    ##                      [0.094, 0.171, 0.64, 0.095]]}
    return(pwm_dict)



def get_seq_score(seq, pwm_score_list):
    # if len(seq) != len(pwm_score_list):
        # sys.stderr.write('Error: Length unequal\n')
        # sys.exit(1)
    
    pwm_map = {"A":0, "C":1, "G":2, "T":3}
    score = 0
    for seq_base_pos, seq_base in enumerate(seq):
        seq_base = seq_base.upper()
        score += Decimal(math.log(Decimal(str(pwm_score_list[seq_base_pos][pwm_map[seq_base]]))/Decimal('0.25')))
    return(int(round(score, 0)))
    
    
def find_pwm_list_by_length(motif_pwm_list, seq_len):
    result = {}
    for pwm_num, pwm_score_list in enumerate(motif_pwm_list):
        if len(pwm_score_list) == seq_len:
            result[pwm_num+1] = pwm_score_list
    return(result)
    

## Read Homer bed file
pwm_dict = convert_pwm2dict(motif_pwm_path, updated_motif_pwm_path)
pre_line_data = [None]*7
line_counter = 0
offset = 0 ## Using for jumping the next PWM when an identical record found

with gzip.open(row_homer_bed_path, 'rb') as motif_bed, gzip.open(updated_homer_bed_path, 'wt') as updated_motif_bed:
    
    for line in tqdm(motif_bed, desc='Updating motif names', file=sys.stdout):
        line_counter+=1
        line_data = line.strip().split("\t") ## 0:"motif_chr", 1:"motif_start", 2:"motif_end", 3:"motif_name", 4:"log_odds_score", 5:"motif_strand", 6:"motif_seq"
        
        is_diff = False
        for curr, pre in zip(line_data, pre_line_data):
            if curr != pre:
                is_diff = True
                offset = 0 ## Reset offset
        if not is_diff: offset += 1
        
        motif_name = line_data[3].split("/")[0]
        if motif_name in need_change_names_by_scoring:
            found_pwm = find_pwm_list_by_length(pwm_dict[motif_name], len(line_data[6]))
            is_update = False
            original_score = ''
            seeking_times = 0  ## Using for counting times in the loop below when the score is matched.
            for pwm_num, pwm_score_list in found_pwm.iteritems():
                new_motif_name = motif_name + suffix + str(pwm_num)
                score = get_seq_score(line_data[6], pwm_score_list)
                original_score += line_data[4]+','
                if int(line_data[4]) == score:
                    if offset == seeking_times:  ## Picking up PWM when offset == seeking_times
                        updated_motif_bed.write(('%s\t%s\t%s\n') % ('\t'.join(line_data[:3]), new_motif_name+'\t'+line_data[4], '\t'.join(line_data[5:])))
                        is_update = True
                    
                    seeking_times += 1
                    
            if len(found_pwm) == 0: ## No PWM found
                if skipped_error_line:
                    sys.stderr.write('Skipped Line %d: %s sequence length (%d) in the BED file is not equal to PWM\n' % (line_counter, motif_name, len(line_data[6])))
                else:
                    sys.stderr.write('Line %d: %s sequence length (%d) in the BED file is not equal to PWM\n' % (line_counter, motif_name, len(line_data[6])))
                    
                    updated_motif_bed.write(line)
                    
            elif not is_update:
                if skipped_error_line:
                    sys.stderr.write('Skipped Line %d: New score (%d) is not equal to the original one (%s)\n' % (line_counter, score, original_score[:-1]))
                else:
                    sys.stderr.write('Line %d: New score (%d) is not equal to the original one (%s)\n' % (line_counter, score, original_score[:-1]))
                    
                    updated_motif_bed.write(line)
            
        elif motif_name in need_change_names_by_length:
            found_pwm = find_pwm_list_by_length(pwm_dict[motif_name], len(line_data[6]))
            if len(found_pwm) == 0: ## No PWM found
                if skipped_error_line:
                    sys.stderr.write('Skipped Line %d: %s sequence length (%d) in the BED file is not equal to PWM\n' % (line_counter, motif_name, len(line_data[6])))
                else:
                    sys.stderr.write('Line %d: %s sequence length (%d) in the BED file is not equal to PWM\n' % (line_counter, motif_name, len(line_data[6])))
                    
                    updated_motif_bed.write(line)
            else:
                pwm_num = found_pwm.keys()[0] ## Only one PWM should be picked up because PWMs with the same length are considered in the need_change_names_by_scoring list
                # pwm_score_list = found_pwm[pwm_num] ## No need here
                new_motif_name = motif_name + suffix + str(pwm_num)
                updated_motif_bed.write(line.replace(motif_name, new_motif_name))
        
        else: updated_motif_bed.write(line)
        pre_line_data = line_data
