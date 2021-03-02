#!/bin/bash

SPACE=$1
BRANCH=${GITHUB_REF##*/}
echo "working in branch ${BRANCH}"
echo "Space: ${SPACE}"
cd blueprints || exit 1;

for f in *.yaml; do
  BP=${f%.yaml}
  echo "Validating ${BP}..."
  colony --token $COLONY_TOKEN --space $SPACE bp validate ${BP} --branch $BRANCH  
#  printf '%s\n' "${f%.yaml}"
done

# colony --help
