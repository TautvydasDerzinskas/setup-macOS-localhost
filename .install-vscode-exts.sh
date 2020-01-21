if [ -x "$(command -v code)" ]; then
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    NO_COLOR='\033[0m'

    # Extensions
    exts=(
        formulahendry.auto-close-tag
        formulahendry.auto-rename-tag
        equinusocio.vsc-community-material-theme
        editorconfig.editorconfig
        eamodio.gitlens
        tautvydasderzinskas.vscode-html-to-css
        zignd.html-css-class-completion
        pkief.material-icon-theme
        equinusocio.vsc-material-theme
        equinusocio.vsc-material-theme-icons
        searking.preview-vscode
        shardulm94.trailing-spaces
        ms-vscode.vscode-typescript-tslint-plugin
        vscode-icons-team.vscode-icons
    )

    count=${#exts[@]}
    echo -e "\n*** Preparing to install the following VSCode Extensions ($count):\n"

    for ext in "${exts[@]}"; do
        echo -e "${BLUE}Installing:${GREEN} $ext"
        code --install-extension $ext
        echo "" # new line exec above
    done
else
    echo "*** Could not install visual studio plugins"
fi