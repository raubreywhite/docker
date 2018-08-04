#!/bin/bash
export NOCACHE=--no-cache
if [[ "$CI_PWD" == "" ]]; then
    export CI_PWD=$HOME/git/
    export NOCACHE=" "
fi

source $CI_PWD/docker/bin/R_VERSION.sh

docker build --pull --no-cache --tag=raw996/dhadley:$RVERSION --build-arg RVERSION=$RVERSION $CI_PWD/docker/dhadley

docker build --pull --no-cache --tag=raw996/dp:gpu --build-arg FROM_IMAGE=nvcr.io/nvidia/tensorflow:18.04-py3 $CI_PWD/docker/dp

docker build --pull --no-cache --tag=raw996/dp:cpu --build-arg FROM_IMAGE =tensorflow/tensorflow:1.10.0-rc1-py3 $CI_PWD/docker/dp

