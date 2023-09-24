#!/bin/sh

# This script will launch the cub3D binary with all the maps in the folder maps/bad

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


# check if the path is valid
if [ ! -f "../cub3D" ]; then
	echo "No cub3D binary found in the parent folder"
	exit 1
fi

# ask if the user want to test the bonus executable (default is no)
echo "Do you want to test the bonus executable? (y/N)"
read -r bonus
bonus=${bonus:-n}
if [ "$bonus" = "y" ]; then
	exe_bonus="../cub3D_bonus"
	if [ ! -f "$exe_bonus" ]; then
		echo "No cub3D_bonus binary found at $exe_bonus"
		exit 1
	fi
fi

exe="../cub3D"
maps="./maps"

RED='\033[0;31m'
RESET='\033[0m'

failed=0

echo "$maps"

for file in "$maps"/*.cub
do
	timeout 1s $exe "$file" > /dev/null 2>&1

	if [ $? -eq 124 ]; then
		echo "${RED}$file timeout${RESET}"
		failed=$((failed+1))
	fi
done
echo "$failed tests failed"

if ( [ "$bonus" = "y" ] ); then
	failed=0
	echo "Testing the bonus executable"
	for file in "$maps"/*.cub
	do
		timeout 1s $exe_bonus "$file" > /dev/null 2>&1

		if [ $? -eq 124 ]; then
			echo "${RED}$file timeout${RESET}"
			failed=$((failed+1))
		fi
	done
	echo "$failed tests failed for the bonus executable"
fi

