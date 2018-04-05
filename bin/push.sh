#!/bin/bash
if [[ "$CI_PWD" == "" ]]; then
    export CI_PWD=$HOME/git/
fi

source $CI_PWD/docker/bin/R_VERSION.sh
docker push raw996/dhadley:$RVERSION

