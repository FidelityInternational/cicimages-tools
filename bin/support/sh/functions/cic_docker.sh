#!/usr/bin/env bash
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

function cic_image() {
    echo "lvlup/ci_course"
}

function cic_tag() {
    echo "$(cic_image):${RANDOM}"
}


function copy_to_cic_volume() {
    local path=$1
    local volume_path=$2
    docker cp "${path}" "$(cic_volumes_container):${volume_path}" > /dev/null
}

