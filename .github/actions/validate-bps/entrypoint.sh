#!/bin/bash

BRANCH=${GITHUB_REF##*/}
echo "working in branch ${BRANCH}"

cd blueprints || exit 1;

for f in *.yaml; do
  echo "Validating ${f}..."
#  printf '%s\n' "${f%.yaml}"
done

colony --help