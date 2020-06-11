#!/bin/bash

function helpDocs {
  # show the help docs
  echo "$(tput setaf 4)---------------------------"
  echo "$(tput setaf 7) NG1 help"
  echo "$(tput setaf 2) ng1 new sampleName:$(tput setaf 7) Create project with name sampleName"
  echo "$(tput setaf 2) ng1 module sampleName:$(tput setaf 7) Create module with name sampleName"
  echo "$(tput setaf 2) ng1 direcive sampleName:$(tput setaf 7) Create directive with name sampleName"
  echo "$(tput setaf 2) ng1 factory sampleName:$(tput setaf 7) Create factory with name sampleName"
  echo "$(tput setaf 2) ng1 service sampleName:$(tput setaf 7) Create service with name sampleName"
  echo "$(tput setaf 2) ng1 value sampleName:$(tput setaf 7) Create value with name sampleName"
  echo "$(tput setaf 2) ng1 constant sampleName:$(tput setaf 7) Create constant with name sampleName"
  echo "$(tput setaf 2) ng1 filter sampleName:$(tput setaf 7) Create filter with name sampleName"
  echo "$(tput setaf 2) ng1 rm sampleName:$(tput setaf 7) Remove module with name sampleName"
  echo "$(tput setaf 2) ng1 rm sampleName filter:$(tput setaf 7) remove filter with name sampleName (will check all modules)"
  echo "(the above can also be used with: service, directive, factory etc just not module)"
  echo "$(tput setaf 4)---------------------------$(tput sgr0)"

}
