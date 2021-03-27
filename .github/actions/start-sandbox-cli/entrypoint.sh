#!/bin/bash

# Compose options or command
COLONY_OPTS="--token ${INPUT_COLONY_TOKEN} --space ${INPUT_SPACE}"

if [ ${INPUT_DEBUG^^} = 'TRUE' ]; then
	COLONY_OPTS+=" --debug"
fi

COLONY_START_OPTS="${INPUT_BLUEPRINT_NAME} --branch ${INPUT_BRANCH} --duration ${INPUT_DURATION}"

[ -n "${INPUT_SANDBOX_NAME}" ] && COLONY_START_OPTS+=" --name ${SANDBOX_NAME}"
[ -n "${INPUT_ARTIFACTS}" ] && COLONY_START_OPTS+=" --artifacts ${INPUT_ARTIFACTS}"
[ -n "${INPUT_INPUTS}" ] && COLONY_START_OPTS+=" --inputs ${INPUT_INPUTS}"

if [ ${INPUT_TIMEOUT} != '0' ]; then
	COLONY_START_OPTS+=" --wait ${INPUT_TIMEOUT}"
fi

colony $COLONY_OPTS sb start $COLONY_START_OPTS | tee log.txt

SANDBOX_ID=$(cat log.txt | grep "Id:" | sed 's/Id: //')
echo "::set-output name=sandbox-id::$(echo $SANDBOX_ID)"
