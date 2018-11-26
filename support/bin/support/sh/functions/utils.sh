#!/usr/bin/env bash

function exit_unless_var_defined() {
    local env_variable=$1
    if [[ -z $(eval "echo \${${env_variable}}") ]]
    then
        echo "please set ${env_variable}"
        exit 1
    fi
}

function exit_unless_file_exists() {
    local path=$1

    if [[ ! -f  "${path}" ]]
    then
        echo "File does not exist: ${path}"
        exit 1
    fi
}

function exit_unless_directory_exists() {
    local path=$1

    if [[ ! -d  "${path}" ]]
    then
        echo "File does not exist: ${path}"
        exit 1
    fi
}