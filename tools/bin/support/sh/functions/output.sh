#!/usr/bin/env bash
function red(){
    local red='\033[0;31m'
    local no_colour='\033[0m'
    local text=$1
    echo "${red}${text}${no_colour}"
}

function green(){
    local green='\033[0;32m'
    local no_colour='\033[0m'
    local text=$1
    echo "${green}${text}${no_colour}"
}

function error() {
    local text=$1
    red "[ ERROR ] ${text}"
}

function ok(){
    local text=$1
    green "[ OK ] ${text}"
}

function say(){
    echo -e "$@"
}