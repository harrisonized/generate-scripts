#!/usr/bin/env bash
set -e  # exit on error


# params
export input_dir="data/input"
export output_dir='scripts'
export log_dir='logs'


# set working directory
export wd="$HOME/github/script-generator"
cd $wd

# make output_dirs if not exists
if ! test -d "$output_dir" ; then
    mkdir $output_dir
    echo "TRUE"
fi

# for loop
start_time=$(date +'%Y%m%d_%H%M%S')
log_filepath="$log_dir/generate_scripts-$start_time.log"

echo "START $(date +'%Y%m%d_%H%M%S')"

input_files_glob="$input_dir/*"
declare -a input_files=($input_files_glob)
for input_file in ${input_files[@]}
do
    # get input_filename
    declare -a input_path_levels=($(echo $input_file | tr "/" " "))  # input_file.split('/')
    input_filename=${input_path_levels[${#input_path_levels[@]}-1]}  # get last element
    filename_no_ext=${input_filename/.txt/""}
    output_script="$output_dir/${filename_no_ext}.sh"

    # Fill in different parameters per file
    cat <<EOT > $output_script
#!/usr/bin/env bash
set -e  # exit on error

# options
export genome_dir='data/ref'
export num_threads=6
export input_dir="data/input"
export input_filename=$input_filename
export output_dir='data/output'
export output_sam_type = 'BAM SortedByCoordinate'
EOT
    
    # Append with shared code
    cat <<\EOT >> $output_script
export log_dir='logs'

export wd="$HOME/github/script-generator"
cd $wd
pwd
echo ""

# make output_dir if not exists
if ! test -d "$output_dir" ; then
    mkdir $output_dir
    echo "TRUE"
fi
if ! test -d "$log_dir" ; then
    mkdir $log_dir
    echo "TRUE"
fi

start_time=$(date +'%Y%m%d_%H%M%S')
log_filepath="$log_dir/generate_scripts-$start_time.log"

module load STAR

STAR --genomeDir $genome_dir \
--runThreadN $num_threads \
--readFilesIn $input_dir \
--outFileNamePrefix $output_dir \
--outSAMtype $output_sam_type

current_time=$(date +'%Y%m%d_%H%M%S')
echo "END $current_time"
EOT

done

current_time=$(date +'%Y%m%d_%H%M%S')
echo "END $current_time"
