#!/bin/bash

# colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
COLORRESET='\033[0m' 

shopt -s extglob

npm_pkgs=()

syntax_note() {
  printf "Please specify the project name: 
  ${CYAN}react-app ${GREEN}<project-name> ${COLORRESET}[-r] [-s]\n"
}

install_modules() {
  printf "\n${CYAN}Install React App ...${COLORRESET}\n"
  npx create-react-app $1
}

customize_react_app() {
  printf "\n${CYAN}Customize the App ...${COLORRESET}\n"

  # Delete files
  rm $project_dir/src/index.js $project_dir/src/App.js $project_dir/src/App.test.js $project_dir/src/logo.svg $project_dir/src/App.css $project_dir/src/index.css $project_dir/src/serviceWorker.js $project_dir/README.md
  rm -rf $project_dir/.git

  # Create folders
  mkdir $project_dir/src/components/ $project_dir/src/assets/ $project_dir/src/assets/scss/ $project_dir/src/assets/img/
  
  # Create files 
  touch $project_dir/src/assets/scss/main.scss $project_dir/src/index.js $project_dir/src/components/App.js 

  # Write default code in files

  echo 'import React from "react";
import ReactDOM from "react-dom";
import App from "./components/App";

ReactDOM.render(<App />, document.querySelector("#root"));' >>$project_dir/src/index.js

  echo 'import React, { Component, Fragment } from "react";

export default class App extends Component {
  render() {
    return ( 
      <Fragment>
        Hello World!
      </Fragment>
    )
  }
}' >>$project_dir/src/components/App.js
}

if [[ $# -lt 1 ]]; then
  syntax_note
else
  for i in $@; do
    case $i in
    -n) npm_pkgs+=('node-sass') ;;
    -r) npm_pkgs+=('react-router-dom') ;;
    -s) npm_pkgs+=('styled-components') ;;
    !(-)) project_dir=$i;
    esac
  done

  install_modules $project_dir

  customize_react_app

  cd $project_dir

  git init
  git add .
  git commit -m "Init React app"

  if [[ ${#npm_pkgs[@]} -gt 0 ]]; then
    printf "\n${CYAN}Install ${GREEN}${npm_pkgs[@]}\n"
    npm install ${npm_pkgs[@]}
  fi

  git add package.json package-lock.json
  git commit -m "Install ${#npm_pkgs[@]} npm packages"

  printf "\n${CYAN}Done!${COLORRESET}\n"

  code .
  npm start

  exec bash

fi