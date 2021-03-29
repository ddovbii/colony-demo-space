#!/bin/bash

# Compose options or command
COLONY_OPTS="--token ${INPUT_COLONY_TOKEN} --space ${INPUT_SPACE}"

if [ ${INPUT_DEBUG^^} = 'TRUE' ]; then
	COLONY_OPTS+=" --debug"
fi

echo "Trying to end sandbox with ID: ${INPUT_SANDBOX_ID}"

colony $COLONY_OPTS sb end $INPUT_SANDBOX_ID || (echo "Unable to end sandbox" && exit 1)
