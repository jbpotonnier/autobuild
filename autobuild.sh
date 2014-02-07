#!/bin/bash

DIRECTORY_TO_OBSERVE="."
BUILD_COMMAND="cabal build"
EXCLUDE='\.git|\.idea|_bak___|\.swp|\.iml|\.#.*|.*flymake'

function build {
	bash -c "$BUILD_COMMAND"
}

function block_for_change {
  inotifywait -r \
			-e modify,move,create,delete \
			--exclude $EXCLUDE \
			$DIRECTORY_TO_OBSERVE 2>/dev/null
}

default='\e[39m'
red='\e[31m'
green='\e[32m'

while block_for_change; do
  clear
  build
  if [ $? -ne 0 ] 
  then
    echo -e "${red}Failure${default}"
    notify-send --urgency=low "Build Failed" "${BUILD_COMMAND} \($(basename $(pwd))\)"
  else
    echo -e "${green}Success${default}"
  fi	
done
