#!/bin/bash

# Compose options or command
COLONY_OPTS="--token ${INPUT_COLONY_TOKEN} --space ${INPUT_SPACE}"

if [ ${INPUT_DEBUG^^} = 'TRUE' ]; then
	COLONY_OPTS+=" --debug"
fi

COLONY_START_OPTS="${INPUT_BLUEPRINT_NAME} --branch ${INPUT_BRANCH} --duration ${INPUT_DURATION}"

[ -n "${INPUT_SANDBOX_NAME}" ] && COLONY_START_OPTS+=" --name ${SANDBOX_NAME}"

if [ ${INPUT_TIMEOUT} != '0' ]; then
	COLONY_START_OPTS+=" --wait ${INPUT_TIMEOUT}"
fi

echo "Starting sandbox with the followig options: $COLONY_START_OPTS"
# Ugly, but it's not easy to include quoted artifacts and inputs to COLONY_START_OPTS
echo "Artifacts: --artifacts: ${INPUT_ARTIFACTS}"
echo "Inputs: --inputs:  ${INPUT_INPUTS}"

colony $COLONY_OPTS sb start $COLONY_START_OPTS --inputs "${INPUT_INPUTS}" --artifacts "${INPUT_ARTIFACTS}" | tee log.txt

if [ ${PIPESTATUS[0]} = '1' ]; then echo "An error occurred during sandbox launching" && exit 1; fi

SANDBOX_ID=$(cat log.txt | grep "Id:" | sed 's/Id: //')

echo "::set-output name=sandbox-id::$(echo $SANDBOX_ID)"
echo "Sandbox ID ${SANDBOX_ID} is set as output"
