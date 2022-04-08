#!/bin/bash

DOCKER_USER=${1}
REPO=${2}

docker login --username $DOCKER_USER
docker build -t ${REPO} -f app/Dockerfile app/
docker push ${REPO}
