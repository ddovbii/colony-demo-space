#!/bin/bash

<<<<<<< HEAD
BRANCH=${GITHUB_REF##*/}
FILES_TO_VALIDATE=()

echo "Working in branch ${BRANCH}"
echo "Space: ${INPUT_SPACE}"

echo "Files from the user input ${INPUT_FILESLIST}"

[ -d "./blueprints" ] || (echo "Wrong repo. No blueprints/ directory" && exit 1);

if [ -n "$INPUT_FILESLIST" ]; then

	for path in $INPUT_FILESLIST; do
		# highlevel dir
		FOLDER=$(dirname $path | cut -d/ -f 1);

		if [ $FOLDER = "blueprints" ]; then
			# do nothing, just add to validation list 
			FILES_TO_VALIDATE+=("${path}")
			
		elif [ $FOLDER == "applications" ] || [ $FOLDER == "services" ]; then
		  # find corresponding blueprint
			resource=$(dirname $path | cut -d/ -f 2)
			echo "Find blueprints which depend on ${resource}"
      
      while read bp;
      do
        if [[ ! " ${FILES_TO_VALIDATE[@]} " =~ " ${bp} " ]]; then
					echo "Adding ${bp} to the list"
					FILES_TO_VALIDATE+=("${bp}")
				fi
			done < <(grep -l -r blueprints/ -e $resource)
		else
			echo "Skipping ${path}"
		fi
	done
  echo "Final list of files to validate"
  echo ${FILES_TO_VALIDATE[@]}
else
	FILES_TO_VALIDATE=(blueprints/*.yaml)
fi
=======
SPACE=$1
FILES=$2
BRANCH=${GITHUB_REF##*/}

FILES_TO_VALIDATE=()

echo "Working in branch ${BRANCH}"
echo "Space: ${SPACE}"
<<<<<<< HEAD
echo "Files to validate ${FILES}"
<<<<<<< HEAD
<<<<<<< HEAD
cd blueprints || exit 1;
<<<<<<< HEAD
# echo ${GITHUB_EVENT_NAME}
# echo "List of changed files:"
#echo "CHANGED_FILES=$(git diff --name-only ${GITHUB_EVENT_BEFORE}..${GITHUB_EVENT_AFTER})"
<<<<<<< HEAD
env
>>>>>>> pass changed files

err=0

for ((i = 0; i < ${#FILES_TO_VALIDATE[@]}; i++)); do
	bpname=`echo ${FILES_TO_VALIDATE[$i]} | sed 's,blueprints/,,' | sed 's/.yaml//'`
	echo "Validating ${bpname}..."
	colony --token $INPUT_COLONY_TOKEN --space $INPUT_SPACE bp validate "${bpname}" --branch $BRANCH || ((err++))
done
=======
=======
=======
[ -d "./blueprints" ] || echo "No blueprints/ directory" && exit 1;
>>>>>>> Update entrypoint.sh
=======
[ -d "./blueprints" ] || (echo "No blueprints/ directory" && exit 1);
>>>>>>> Update entrypoint.sh
=======

echo "Files from the user input ${FILES}"

[ -d "./blueprints" ] || (echo "Wrong repo. No blueprints/ directory" && exit 1);
>>>>>>> Initiate array

if [ -n "$FILES" ]; then

	for path in $FILES; do
		# highlevel dir
		FOLDER=$(dirname $path | cut -d/ -f 1);

		if [ $FOLDER = "blueprints" ]; then
			# do nothing, just add to validation list 
			FILES_TO_VALIDATE+=("${path}")
			
		elif [ $FOLDER == "applications" ] || [ $FOLDER == "services" ]; then
		  # find corresponding blueprint
			resource=$(dirname $path | cut -d/ -f 2)
			echo "Find bplueprints which depend on ${resource}"
      grep -l -r blueprints/ -e $resource |
      while read bp;
      do
        if [[ ! " ${FILES_TO_VALIDATE[@]} " =~ " ${bp} " ]]; then
					echo "Adding ${bp} to the list"
					FILES_TO_VALIDATE+=("${bp}")
				fi
			done
		else
			echo "Skipping ${path}"
		fi
	done
  echo "Final list of files to validate"
  echo ${FILES_TO_VALIDATE[@]}
else
	FILES_TO_VALIDATE=(blueprints/*.yaml)
fi
>>>>>>> all bps

err=0

for ((i = 0; i < ${#FILES_TO_VALIDATE[@]}; i++)); do
	bpname=`echo ${FILES_TO_VALIDATE[$i]} | sed 's,blueprints/,,' | sed 's/.yaml//'`
	echo "Validating ${bpname}..."
	colony --token $COLONY_TOKEN --space $SPACE bp validate "${bpname}" --branch $BRANCH || ((err++))
done
<<<<<<< HEAD
  
# for f in *.yaml; do
#   BP=${f%.yaml}
#   echo "Validating ${BP}..."
#   colony --token $COLONY_TOKEN --space $SPACE bp validate "${BP}" --branch $BRANCH || ((err++))
#   echo "**********************************************************************"
# #  printf '%s\n' "${f%.yaml}"
# done
>>>>>>> test
=======
>>>>>>> Initiate array

echo "Number of failed blueptints: ${err}"

if (( $err > 0 )); then
	  exit 1;
fi
