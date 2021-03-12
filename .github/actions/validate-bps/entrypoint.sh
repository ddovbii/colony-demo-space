#!/bin/bash

SPACE=$1
FILES=$2
BRANCH=${GITHUB_REF##*/}

echo "working in branch ${BRANCH}"
echo "Space: ${SPACE}"
echo "Files to validate ${FILES}"
cd blueprints || exit 1;

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
else
  FILES_TO_VALIDATE=(blueprints/*.yaml)
fi

err=0

for ((i = 0; i < ${#FILES_TO_VALIDATE[@]}; i++)); do
  #if [[ $f == blueprints/* ]] ;
  #then
  bpname=`echo ${FILES_TO_VALIDATE[$i]} | sed 's,blueprints/,,' | sed 's/.yaml//'`
  echo "Validating ${bpname}..."
  colony --token $COLONY_TOKEN --space $SPACE bp validate "${bpname}" --branch $BRANCH || ((err++))
  #else
  #  echo "Skipping file ${f}"
  #fi
done
  
# for f in *.yaml; do
#   BP=${f%.yaml}
#   echo "Validating ${BP}..."
#   colony --token $COLONY_TOKEN --space $SPACE bp validate "${BP}" --branch $BRANCH || ((err++))
#   echo "**********************************************************************"
# #  printf '%s\n' "${f%.yaml}"
# done

echo "Number of failed blueptints: ${err}"

if (( $err > 0 )); then
  exit 1;
fi

# colony --help
