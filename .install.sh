if [[ $(id -u) -ne 0 ]]; then
    echo "*** Not running as sudo..."
    echo "Please re-run this script as sudo, it is required:"
    echo "a) To install some applications"
    echo "b) To install global NPM dependencies"
fi

# Install Homebrew
echo "** Installing Homebrew"
if ! [ -x "$(command -v brew)" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update
else
    echo "** Brew detected"
fi

if [ -x "$(command -v brew)" ] && ! [ -x "$(command -v git)" ]; then
    echo "** Installing Git"
    brew install git
else
    echo "** Git detected"
fi

echo "** Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

if [ -x "$(command -v git)" ]; then
    echo "** Installing PowerLine fonts"
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
fi

# Brew installations
if [ -x "$(command -v brew)" ]; then
    brew tap caskroom/cask
    brew install tree

    echo "** Installing Visual Studio Code"
    brew cask search visual-studio-code
    brew cask install visual-studio-code
    # Installing code CLI command
    ln -fs "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/
fi

if [ -x "$(command -v nvm)" ]; then
    echo "** Installing NVM (Node.js + NPM)"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
    nvm install --lts
    nvm alias default --lts
else
    echo "** NVM detected"
fi

# Install npm global dependenvcies
sh "${SETUP_HOME_DIR}/.install-npm-globals.sh"

# Install VS Code extensions
sh "${SETUP_HOME_DIR}/.install-vscode-exts.sh"