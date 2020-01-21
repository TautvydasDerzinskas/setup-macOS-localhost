#!/bin/bash

# Updating bootstrap counter
file="${SETUP_HOME_DIR}.bootstrap.txt"
if ! test -f "$file"; then
  echo "*** Creating bootstrap counter DB file"
  touch file
fi
currentDate=$(date)

if [ -e "$file" ]; then
  starts=$(head -1 $file)
echo "$since"
else
  starts=0
fi
echo "$(($starts + 1))" > $file

# Colors
RCol='\x1B[0m'
Bla='\x1B[0;30m';
Cya='\x1B[0;36m';
Blu='\x1B[0;34m';
Whi='\x1B[0;37m';
BRed='\x1B[1;31m';

# Main info
version="3.0.0"
title="*** Tautvydas Derzinskas .zshrc config $version"
helpCommand="help-list"

echo "${Bla}--------------------------------------------${RCol}";
echo "${Red}  $title  ${RCol}";
echo "${Bla}--------------------------------------------${RCol}";
echo "${Cya}* ${Whi}Current date${RCol} - ${BRed}$currentDate${RCol}"
echo "${Blu}* ${Whi}Runs${RCol} - ${BRed}$(($starts + 1))${RCol}";
echo "${Cya}* ${Whi}Find out available commands by typing${RCol} - ${BRed}$helpCommand${RCol}"
echo "${Bla}--------------------------------------------${RCol}";

# echo "${Cya}* ${Whi}zshconf${RCol} - ${Yel}open zsh configuration file${RCol}";
# echo "${Cya}* ${Whi}open-report${RCol} - ${Yel}opens serenity report file${RCol}";
# if [ -x "$(command -v brew)" ]; then
#   echo "${Blu}* ${Whi}brew-update${RCol} - ${Yel}bew proper update chain${RCol}";
# fi
# echo "${Cya}* ${Whi}node-old${RCol} - ${Yel}switching to node version 5.8.0${RCol}";
# echo "${Blu}* ${Whi}node-new${RCol} - ${Yel}switching to node version 8.9.4${RCol}";
# echo "${Cya}* ${Whi}git-repos${RCol} - ${Yel}cd to git projects directory${RCol}";
# echo "${Blu}* ${Whi}awscli${RCol} - ${Yel}aws okta cli command${RCol}"
# if [ -x "$(command -v ncu)" ]; then
#   echo "${Cya}* ${Whi}ncu${RCol} - ${Yel}npm check update${RCol}"
# fi
# echo "";
# if [ -x "$(command -v git)" ]; then
#   echo "${Bla}--------------- ${Red}Git commands${Bla} ---------------${RCol}";
#   echo "${Blu}* ${Whi}pull${RCol} - ${Yel}shortcut for <git pull>${RCol}";
#   echo "${Blu}* ${Whi}amend${RCol} - ${Yel}shorcut for <git commit --amend>${RCol}";
#   echo "${Cya}* ${Whi}cz / commit${RCol} - ${Yel}shorcut for <git cz>${RCol}";
#   echo "";
# fi
# echo "${Bla}--------------- ${Red}Docker commands${Bla} ---------------${RCol}";
# echo "${Blu}* ${Whi}docker-perform${RCol} - ${Yel}pulls and ups${RCol}";
# echo "${Blu}* ${Whi}docker-clear${RCol} - ${Yel}deletes all containers and images${RCol}";
# echo "${Bla}--------------------------------------------${RCol}";