# install command line tools
xcode-select --install

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install necessary packages
brew install openssl
brew install samtools
brew install wget
brew install miller
brew install jq
brew install md5sha1sum 

