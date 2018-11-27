#!/usr/bin/env bash
SURROUNDED_WITH_SINGLE_QUOTES="^\'.*\'$"
SURROUNDED_WITH_DOUBLE_QUOTES="^\".*\"$"
STARTS_WITH_HYPHEN="^-"
EQUALS_SIGN='='

_FUNCTIONS_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=bin/support/sh/functions/cic.sh
source "${_FUNCTIONS_PATH}/cic.sh"


function content_after() {
    local matcher=$1
    grep -o "${matcher}.*" | sed -e s/"^${matcher}"//
}

function content_before(){
    local matcher=$1
    cut -d "${matcher}" -f 1
}

function sanitise_value(){
    local unsanitised_value=$1
    if [[ "${unsanitised_value}" =~ ${SURROUNDED_WITH_DOUBLE_QUOTES} ]]
    then
        echo "'${unsanitised_value}'"
    else
        echo "\"${unsanitised_value}\""
    fi
}


function sanitise_option(){
    local unsanitised_option=$1

    local option
    option=$(echo "${unsanitised_option}" | content_before "=")
    local value
    value=$(echo "${unsanitised_option}" | content_after "=" )

    if [[ ! "${value}" =~ ${SURROUNDED_WITH_SINGLE_QUOTES} ]] &&
        [[ ! "${value}" =~ ${SURROUNDED_WITH_DOUBLE_QUOTES} ]]
    then
        echo "${option}=$(sanitise_value "${value}")"
    else
        echo "${unsanitised_option}"
    fi

}

function build_command(){
    local command=$1
    shift

    for argument in "$@"
    do
        if [[ "${argument}" =~ ${STARTS_WITH_HYPHEN} ]] && [[ "${argument}" =~ ${EQUALS_SIGN} ]]
        then
            argument=$(sanitise_option "${argument}")
        elif [[ "${argument}" =~ ${EQUALS_SIGN} ]]
        then
           argument=$(sanitise_value "${argument}")
        fi
        command="${command} ${argument}"
    done

    echo "${command}"
}

function standard_docker_options(){
    echo "-t --privileged" \
         "--network $(cic_network)" \
         "-v $(working_directory):$(cic_working_dir)" \
         "-w $(cic_working_dir)"

}

function run_wrapped_command(){
    local image=$1
    shift
    local command=$1
    shift

    docker run \
    $(standard_docker_options) \
    "${image}" /bin/bash -ilc "$(build_command "${command}" $@)"
}
