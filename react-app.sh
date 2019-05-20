#!/bin/bash

# colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
COLORRESET='\033[0m' 

shopt -s extglob

syntax_note() {
  printf "Please specify the project name: 
  ${CYAN}react-app ${GREEN}<project-name>\n"
}

install_modules() {
  printf "\n${CYAN}Install React App ...\n"
  npx create-react-app $1
}

if [[ $# -lt 1 ]]; then
  syntax_note
else
  project_dir=$1;

  install_modules $project_dir

  printf "\n${CYAN}Done!\n"

fi