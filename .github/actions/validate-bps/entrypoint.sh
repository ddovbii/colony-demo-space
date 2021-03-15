#!/bin/bash

SPACE=$1
FILES=$2
BRANCH=${GITHUB_REF##*/}

FILES_TO_VALIDATE=()

echo "Working in branch ${BRANCH}"
echo "Space: ${SPACE}"

echo "Files from the user input ${FILES}"

[ -d "./blueprints" ] || (echo "Wrong repo. No blueprints/ directory" && exit 1);

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
  FILES_TO_VALIDATE+=("abc")
  echo "Final list of files to validate"
  echo ${FILES_TO_VALIDATE[@]}
else
	FILES_TO_VALIDATE=(blueprints/*.yaml)
fi

err=0

for ((i = 0; i < ${#FILES_TO_VALIDATE[@]}; i++)); do
	bpname=`echo ${FILES_TO_VALIDATE[$i]} | sed 's,blueprints/,,' | sed 's/.yaml//'`
	echo "Validating ${bpname}..."
	colony --token $COLONY_TOKEN --space $SPACE bp validate "${bpname}" --branch $BRANCH || ((err++))
done

echo "Number of failed blueptints: ${err}"

if (( $err > 0 )); then
	  exit 1;
fi
