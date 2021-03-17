#!/bin/bash

FILES=$1

FILES_TO_VALIDATE=()

if [ -n "$FILES" ]; then
	echo "The following list of files passed to the job:"
	echo $FILES

	for path in $FILES; do
		# highlevel dir
		FOLDER=$(dirname $path | cut -d/ -f 1);

		if [ $FOLDER = "blueprints" ]; then
			# do nothing, just add to validation list 
			FILES_TO_VALIDATE+=("${path}")
			
		elif [ $FOLDER == "applications" ] || [ $FOLDER == "services" ]; then
		    # find corresponding blueprint
			substr=$(dirname $path | cut -d/ -f 2)
			echo "Find bplueprints which depend on ${substr}"
			bplist=$(grep -l -r blueprints/ -e $substr)

			for bp in $bplist; do
				if [[ ! " ${FILES_TO_VALIDATE[@]} " =~ " ${bp} " ]]; then
					echo "Adding ${bp} to the list"
					FILES_TO_VALIDATE+=("${bp}")
				fi
			done
		else
			echo "Skipping ${path}"
		fi
	done
fi
FILES_TO_VALIDATE+=("abc")
echo "${FILES_TO_VALIDATE[@]}"


#echo $FILES | tr " " "\n" | grep -vE ".(yaml)$"
