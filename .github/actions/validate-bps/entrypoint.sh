#!/bin/bash

SPACE=$1
BRANCH=${GITHUB_REF##*/}
echo "working in branch ${BRANCH}"

cd blueprints || exit 1;

for f in *.yaml; do
  echo "Validating ${f}..."
  colony --token $COLONY_TOKEN --space $SPACE bp validate ${f%.yaml} -b $BRANCH  
#  printf '%s\n' "${f%.yaml}"
done

# colony --help
