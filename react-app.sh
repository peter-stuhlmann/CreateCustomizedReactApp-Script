#!/bin/bash

# colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
COLORRESET='\033[0m' 

shopt -s extglob

npm_pkgs=()

syntax_note() {
  printf "Please specify the project name: 
  ${CYAN}react-app ${GREEN}<project-name> ${COLORRESET}[-r] [-t] [-b] [-m]\n"
}

install_modules() {
  printf "\n${CYAN}Install React App ...\n"
  npx create-react-app $1

  printf "\n${CYAN}Install node-sass ...\n"
  npm i node-sass --prefix $project_dir/
}

customize_react_app() {
  printf "\n${CYAN}Customize the App ...\n"

  # Delete files
  rm $project_dir/src/index.js $project_dir/src/App.js $project_dir/src/App.test.js $project_dir/src/logo.svg $project_dir/src/App.css $project_dir/src/index.css $project_dir/README.md
  
  # Create folders
  mkdir $project_dir/src/components/ $project_dir/src/assets/ $project_dir/src/assets/scss/ $project_dir/src/assets/img/
  
  # Create files 
  touch $project_dir/src/assets/scss/main.scss $project_dir/src/index.js $project_dir/src/components/App.js 

  # Write default code in files

  echo 'import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import * as serviceWorker from "./serviceWorker";

ReactDOM.render(<App />, document.querySelector("#root"));' >>$project_dir/src/index.js

  echo 'import React, { Component } from "react";
import "../assets/scss/main.scss"

export default class App extends Component {

  render() {
    return ( 
      <React.Fragment>
        Hello World!
      </React.Fragment>
    )
  }

}' >>$project_dir/src/components/App.js
}


if [[ $# -lt 1 ]]; then
  syntax_note
else
  for i in $@; do
    case $i in
    -r) npm_pkgs+=('react-router-dom') ;;
    -t) npm_pkgs+=('react-meta-tags') ;;
    -b) npm_pkgs+=('react-bootstrap') ;;
    -m) npm_pkgs+=('@material-ui/core') ;;
    !(-)) project_dir=$i;
    esac
  done

  install_modules $project_dir

  if [[ ${#npm_pkgs[@]} -gt 0 ]]; then
    printf "\n${CYAN}Install ${GREEN}${npm_pkgs[@]}\n"
    npm install ${npm_pkgs[@]} --prefix $project_dir/
  fi

  customize_react_app

  printf "\n${CYAN}Done!\n"

  code $project_dir/

fi