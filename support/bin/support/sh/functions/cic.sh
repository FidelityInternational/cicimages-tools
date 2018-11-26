#!/usr/bin/env bash

CIC_PWD="${CIC_PWD:-$(pwd)}"

function tracks_path(){
    echo "${TRACKS_PATH}"
}

function exercises_path(){
    echo "${EXERCISES_PATH}"
}

function cic_pwd(){
    echo "${CIC_PWD}"
}

function cic_dir(){
    echo "/cic"
}

function cic_config_dir(){
  echo "$(cic_dir)/.cic"
}

function cic_bin(){
    echo "$(cic_dir)/bin"
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

    echo "${mounts}"
}


CIC_CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=image/bin/support/sh/functions/cic_docker.sh
source "${CIC_CURRENT_PATH}/cic_docker.sh"


