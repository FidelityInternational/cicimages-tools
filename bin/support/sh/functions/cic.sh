#!/usr/bin/env bash
if [ "${TRACKS_PATH}" == "" ]
then
    TRACKS_PATH="${CURRENT_PATH}/../tracks"
fi

if [ "${EXERCISES_PATH}" == "" ]
then
    EXERCISES_PATH="${CURRENT_PATH}/../exercises"
fi

function tracks_path(){
    echo "${TRACKS_PATH}"
}

function exercises_path(){
    echo "${EXERCISES_PATH}"
}

function cic_exports() {
    echo "TRACKS_PATH=$(tracks_path) EXERCISES_PATH=$(exercises_path)"
}