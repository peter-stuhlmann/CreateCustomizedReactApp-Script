#!/bin/bash

NAME='<your-name>'

# colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
COLORRESET='\033[0m' 

shopt -s extglob

npm_pkgs=()
add_files=()

syntax_note() {
  printf "Please specify the project name: 
  ${CYAN}react-app ${GREEN}<project-name> ${COLORRESET}[-r] [-t] [-b] [-m] [-l]\n"
}

install_modules() {
  printf "\n${CYAN}Install React App ...${COLORRESET}\n"
  npx create-react-app $1

  printf "\n${CYAN}Install node-sass ...${COLORRESET}\n"
  npm i node-sass --prefix $project_dir/
}

customize_react_app() {
  printf "\n${CYAN}Customize the App ...${COLORRESET}\n"

  # Delete files
  rm $project_dir/src/index.js $project_dir/src/App.js $project_dir/src/App.test.js $project_dir/src/logo.svg $project_dir/src/App.css $project_dir/src/index.css $project_dir/README.md
  rm -rf $project_dir/.git

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
    -l) add_files+=('LICENSE') ;;
    !(-)) project_dir=$i;
    esac
  done

  install_modules $project_dir

  if [[ ${#npm_pkgs[@]} -gt 0 ]]; then
    printf "\n${CYAN}Install ${GREEN}${npm_pkgs[@]}\n"
    npm install ${npm_pkgs[@]} --prefix $project_dir/
  fi

  if [[ ${#add_files[@]} -gt 0 ]]; then
    printf "\n${CYAN}Create ${GREEN}${#add_files[@]}${COLORRESET}\n"
    touch $project_dir/${add_files[@]} 
    echo "MIT License

Copyright (c) 2019 ${NAME}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE." >>$project_dir/LICENSE

  fi

  customize_react_app

  printf "\n${CYAN}Done!${COLORRESET}\n"

  code $project_dir/

  cd $project_dir

  git init
  git add .
  git commit -m "Init React project" -m "Install modules:
- npm i create-react-app
- npm i node-sass (to use scss)

Customize React App:
- Create two folders in src: components/ and assets/ respectively assets/scss/
- Move App.js in components/ and add a class App with an empty render function
- Create empty main.scss in assets/scss/ and import it in App.js

Remove unneeded files:
- Remove logo.svg from src/ and the logo import in index.js"

  exec bash

fi