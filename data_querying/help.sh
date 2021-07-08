function Help()
{
	if [ -n "$1" ]; then echo "$1"; fi # print first warning/error message if provided
	echo "Script: $script"
	echo "Summary: $scriptSummary" 
	echo ""
	echo -n "USAGE: $script"
	for arg in "${params[@]}"; do
    p="${arg%%;;;*}"
		req=$( echo "${arg}" | sed 's/;;;/\t/g' | cut -f 2 )
		if [ "${req}" = "r" ]; then
		  echo -n " --$p <$p>"
		else
			echo -n " [--$p <$p>]"
    fi
	done
	echo "";

	for arg in "${params[@]}"; do
    p="${arg%%;;;*}" # parameter name
		v="${arg#*;;;}" # parameter value
		IFS=$'\t' read -r req descr exampleVal defVal clVal < <(echo "${v}" | sed 's/;;;/\t/g') 
		reqDisp="Required" && [ "${req}" = "o" ] && reqDisp="Optional"
		echo -e "[$reqDisp] <$p> = ${descr}. Example: ${exampleVal}. Default: $defVal"
	done #| sort -k1,1r -s

	if [ ! -z "${HELPNOTES}" ]; then
    echo ""
    echo "${HELPNOTES}"
    echo ""
  fi
	if [ ! -z "${HELPEXAMPLES}" ]; then
    echo ""
    echo "${HELPEXAMPLES}"
  fi
	#exit 1
}

function SetParams()
{
	args=("$@")
	num_args="${#args[@]}"

# read command line arguments: assumed to be in '--param value' format
clparams=() # command-line parameters
for (( i=0; i<num_args; ++i )); do
	arg="${args[$i]}"
	#echo "current argument: $arg"
	if [[ "$arg" == "--help" ]]; then
		Help
		exit 0
	fi
  if [[ "$arg" == "--"* ]]; then
    param="${arg#--}" # parameter name
		(( i=i+1 )) # move to the next argument (parameter value)
		next_arg="${args[$i]}"
		value="${next_arg}"
		if [[ " ${params[@]} " =~ " ${param};;;" ]]; then
			clparams+=( "${param};;;${value}" )
		  #params[$param]="${params[$param]};;;${value}" # add provided command-line value to the parameter array
		else
			echo "***ERROR: Unknown parameter $param is specified."
			echo -e "\nCheck help for usage:"
      Help
			exit 1
		fi
  fi
done

for arg in "${params[@]}"; do
	p="${arg%%;;;*}" # parameter name
	v="${arg#*;;;}" # parameter specification 
	IFS=$'\t' read -r isReq descr exampleVal defVal < <(echo "${v}" | sed 's/;;;/\t/g')

	clVal=""
	for clarg in "${clparams[@]}"; do
		clp="${clarg%%;;;*}"
		if [ "${clp}" = "${p}" ]; then
		  clv="${clarg#*;;;}" # command-line value
			clVal="${clv}"
			break
		fi
	done

	if [ "${isReq}" = "r" ] && [ "${clVal}" = "" ]; then
		echo "***ERROR: required parameter $p is not specified"
		echo -e "\nCheck help for usage:"
		Help
		exit 1
	fi
	value=${clVal:-"${defVal}"} # parameter value will be set to the command-line value if provided or to the default value
	#echo "Setting $p=$value"
	export $p="$value" # initialize all parameters with the provided values or defaults
	paramValues+=( "${p};;;${v};;;${value}" ) # param name + original parameter spec + assigned value (command-line or default)
done

}


