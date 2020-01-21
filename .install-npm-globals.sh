if [ -x "$(command -v npm)" ]; then
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    NO_COLOR='\033[0m'

    # Extensions
    exts=(
        commitizen
        husky
        npm-check-updates
        rimraf
        typescript
    )

    count=${#exts[@]}
    echo -e "\nPreparing to install the following NPM Global Dependencies ($count):\n"

    for ext in "${exts[@]}"; do
        echo -e "${BLUE}Installing:${GREEN} $ext"
        npm install $ext -g
        echo "" # new line exec above
    done
else
    echo "*** Could not install global NPM dependencies"
fi