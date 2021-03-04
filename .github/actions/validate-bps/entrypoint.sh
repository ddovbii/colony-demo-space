#!/bin/bash

SPACE=$1
BRANCH=${GITHUB_REF##*/}
echo "working in branch ${BRANCH}"
echo "Space: ${SPACE}"
cd blueprints || exit 1;

echo "List of changed files:"
echo "CHANGED_FILES=$(git diff --name-only ${{ github.event.before }}..${{ github.event.after }})"


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
