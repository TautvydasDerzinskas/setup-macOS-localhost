# setup-macOS-localhost
My setup for a new macOS machine (aliases, scripts, VSCode plugins installation and ect.)

# How to use?
1. Edit `SETUP_HOME_GIT_ROOT_DIR` git repository directory in `source ~/Desktop/GitHub/setup-macOS-localhost/.bootstrap`
2. To use aliases, scripts & similar configurations simply add the following in your `~/.zshrc` file:
```sh
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    source ~/Desktop/GitHub/setup-macOS-localhost/.bootstrap
else
  source ~/Desktop/GitHub/setup-macOS-localhost/.bootstrap-lean
fi
```

3. To setup & install multiple various tool on a fresh machine run in your terminal:
* `sudo ~/Desktop/GitHub/setup-macOS-localhost/.install.sh`

**(modify the paths above if accordingly to your setup)**
