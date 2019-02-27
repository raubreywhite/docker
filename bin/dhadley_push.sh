#!/bin/bash
if [[ "$CI_PWD" == "" ]]; then
    export CI_PWD=$HOME/git/
fi

(echo y) | docker system prune

source $CI_PWD/docker/bin/R_VERSION.sh
docker push raw996/dhadley:$RVERSION

#docker push raw996/dp:gpu
#docker push raw996/dp:cpu

