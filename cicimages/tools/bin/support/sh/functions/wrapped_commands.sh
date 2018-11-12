#!/usr/bin/env bash
SURROUNDED_WITH_SINGLE_QUOTES=^\'.*\'$
SURROUNDED_WITH_DOUBLE_QUOTES=^\".*\"$
STARTS_WITH_HYPHEN=^-
EQUALS_SIGN='='

function content_after() {
    local matcher=$1
    echo $(grep -o "${matcher}.*" | sed -e s/"^${matcher}"//)
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

    local option=$(echo "${unsanitised_option}" | content_before "=")
    local value=$(echo "${unsanitised_option}" | content_after "=" )

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
        if [[ "${argument}" =~ ${STARTS_WITH_HYPHEN} ]] && [[ "${argument}" =~ "${EQUALS_SIGN}" ]]
        then
            argument=$(sanitise_option "${argument}")
        elif [[ "${argument}" =~ "${EQUALS_SIGN}" ]]
        then
           argument=$(sanitise_value "${argument}")
        fi
        command="${command} ${argument}"
    done

    echo "${command}"
}
