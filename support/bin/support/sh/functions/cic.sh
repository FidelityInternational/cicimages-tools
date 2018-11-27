#!/usr/bin/env bash

CIC_PWD="${CIC_PWD:-$(pwd)}"


function cic_network() {
    echo "cic"
}

function cic_image_repository() {
    echo "${CIC_IMAGE}"
}

function cic_image_version() {
    echo "${CIC_IMAGE_VERSION}"
}

function cic_image() {
    echo "$(cic_image_repository):$(cic_image_version)"
}

function cic_pwd(){
    echo "${CIC_PWD}"
}

function working_directory(){

    local current_dir="$(pwd)"

    if [[ "${current_dir}" =~  ^/mnt/cic_working_dir ]]
    then
        result=$(echo "${current_dir}" | sed -e "s/^\/mnt\/cic_working_dir//")
        result="$(cic_pwd)${result}"
    else
        result="${current_dir}"
    fi

    echo "${result}"

}

function cic_dir(){
    echo "/cic"
}


function source_tracks_path() {
    echo "${TRACKS_PATH}"
}

function target_tracks_path(){
    echo "$(cic_dir)/tracks"
}


function source_scaffold_path(){
    echo "${SCAFFOLD_PATH}"
}

function target_scaffold_path(){
    echo "$(cic_dir)/scaffold"
}

function source_scaffold_structure(){
    echo "${SCAFFOLD_STRUCTURE}"
}

function target_scaffold_structure(){
    echo "$(target_scaffold_path)/scaffold.yml"
}

function source_exercises_path(){
    echo "${EXERCISES_PATH}"
}

function target_exercises_path(){
    echo "$(cic_dir)/exercises"
}

function cic_working_dir(){
#    echo "/mnt/cic_working_dir"
    if [[ "$(pwd)" =~ ^/mnt/cic_working_dir ]]
    then
        echo "$(pwd)"
    else
        echo "/mnt/cic_working_dir"
    fi

}


function bootstrap_cic_environment(){
    local cic_exports
    cic_exports="${cic_exports} SCAFFOLD_STRUCTURE=$(target_scaffold_structure)"
    cic_exports="${cic_exports} SCAFFOLD_PATH=$(target_scaffold_path)"
    cic_exports="${cic_exports} TRACKS_PATH=$(target_tracks_path)"
    cic_exports="${cic_exports} EXERCISES_PATH=$(target_exercises_path)"
    cic_exports="${cic_exports} CIC_COURSEWARE_VERSION=$(cic_image_version)"
    cic_exports="${cic_exports} CIC_COURSEWARE_IMAGE=$(cic_image_repository)"
    cic_exports="${cic_exports} CIC_PWD=$(cic_pwd)"
    cic_exports="${cic_exports} CIC_IMAGE=$(cic_image_repository)"
    cic_exports="${cic_exports} CIC_IMAGE_VERSION=$(cic_image_version)"

    echo "${cic_exports}"
}

function docker_mounts(){
    local mounts
    mounts="${mounts} -v /var/run/docker.sock:/var/run/docker.sock"
    mounts="${mounts} -v /sys/fs/cgroup:/sys/fs/cgroup:ro"
    mounts="${mounts} -v "$(source_tracks_path)":$(target_tracks_path)"
    mounts="${mounts} -v "$(source_scaffold_path)":$(target_scaffold_path)"
    mounts="${mounts} -v "$(source_scaffold_structure)":$(target_scaffold_structure)"
    mounts="${mounts} -v "$(source_exercises_path)":$(target_exercises_path)"
    mounts="${mounts} -v "${HOME}/.netrc":/root/.netrc"
    mounts="${mounts} -v $(working_directory):$(cic_working_dir)"

    echo "${mounts}"
}