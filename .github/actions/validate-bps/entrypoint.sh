#!/bin/bash

SPACE=$1
FILES=$2
BRANCH=${GITHUB_REF##*/}
echo "working in branch ${BRANCH}"
echo "Space: ${SPACE}"
echo "Files to validate ${FILES}"
cd blueprints || exit 1;
echo ${GITHUB_EVENT_NAME}
echo "List of changed files:"
#echo "CHANGED_FILES=$(git diff --name-only ${GITHUB_EVENT_BEFORE}..${GITHUB_EVENT_AFTER})"
env

err=0
for f in *.yaml; do
  BP=${f%.yaml}
  echo "Validating ${BP}..."
  colony --token $COLONY_TOKEN --space $SPACE bp validate "${BP}" --branch $BRANCH || ((err++))
  echo "**********************************************************************"
#  printf '%s\n' "${f%.yaml}"
done

echo "Number of failed blueptints: ${err}"

if (( $err > 0 )); then
  exit 1;
fi

# colony --help
