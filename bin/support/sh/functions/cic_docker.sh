#!/usr/bin/env bash
CIC_DOCKER_CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
function volume_path() {
    local prefix=$1
    echo "/vols/${prefix}_${RANDOM}"
}

function cic_volumes_container() {
    echo "cic_volumes"
}

function cic_network() {
    echo "cic"
}

function cic_image_repository() {
    cat "${CIC_DOCKER_CURRENT_PATH}/../../../../.courseware-image"
}

function cic_image_version() {
    cat "${CIC_DOCKER_CURRENT_PATH}/../../../../.courseware-version"
}

function cic_image() {
    echo "$(cic_image_repository):$(cic_image_version)"
}

function cic_tag() {
    echo "$(cic_image_repository):temp-${RANDOM}"
}


function copy_to_cic_volume() {
    local path=$1
    local volume_path=$2
    docker cp "${path}" "$(cic_volumes_container):${volume_path}" > /dev/null
}

