#!/bin/bash

shopt -s extglob

syntax_note() {
  printf "Please specify the project name: react-app <project-name>\n"
}

install_modules() {
  printf "\nInstall React App ...\n"
  npx create-react-app $1
}

if [[ $# -lt 1 ]]; then
  syntax_note
else
  project_dir=$1;

  install_modules $project_dir

  printf "\nDone!\n"

fi