#!/usr/bin/env bash
set -e  # exit on error

# params
export scripts_dir="scripts"
export troubleshooting=true


# set working directory
export wd="$HOME/github/script-generator"
cd $wd

# for loop
start_time=$(date +'%Y%m%d_%H%M%S')
echo "START $(date +'%Y%m%d_%H%M%S')"

input_files_glob="$scripts_dir/*"
declare -a input_files=($input_files_glob)
cd $scripts_dir
for input_file in ${input_files[@]}
do
    # get input_filename
    declare -a input_path_levels=($(echo $input_file | tr "/" " "))  # input_file.split('/')
    input_filename=${input_path_levels[${#input_path_levels[@]}-1]}  # get last element
    
    echo "./${input_filename}"
    if ! $troubleshooting; then
	    chmod +x $input_filename
	    "./$input_filename"
    fi

done

current_time=$(date +'%Y%m%d_%H%M%S')
echo "END $current_time"