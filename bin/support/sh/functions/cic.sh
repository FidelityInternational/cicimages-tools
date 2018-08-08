#!/usr/bin/env bash
TRACKS_PATH="${TRACKS_PATH:-${CURRENT_PATH}/../tracks}"
EXERCISES_PATH="${EXERCISES_PATH:-${CURRENT_PATH}/../exercises}"

function tracks_path(){
    echo "${TRACKS_PATH}"
}

function exercises_path(){
    echo "${EXERCISES_PATH}"
}

function cic_exports() {
    echo "TRACKS_PATH=$(tracks_path) EXERCISES_PATH=$(exercises_path)"
}