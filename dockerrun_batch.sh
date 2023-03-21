#!/bin/bash
# Usage: bash dockerrun_batch.sh /input/files/path /output/files/path /database/path 4(CPU_threads)

# Set default CPU threads to 4
CPU_THREADS=4

# Check if the fourth argument is provided and if it is an integer
if [[ -n $4 && $4 =~ ^[0-9]+$ ]]; then
  CPU_THREADS=$4
fi

# Check if the input, output, and database directories exist
if [ -d "$1" ] && [ -d "$2" ] && [ -d "$3" ]; then
  # Loop through all the files in the input directory
  for file in "$1"/*; do
    # Check if the file is a regular file
    if [ -f "$file" ]; then
      # Print the file name and its contents
      docker run --rm  -v $1:/input -v $2:/output -v $3:/db nekokoe/plasmer:latest /bin/sh /scripts/Plasmer -g /input/$(basename $file) -p $(basename $file) -d /db -t $CPU_THREADS -o /output/$(basename $file) 
    fi
  done
else
  # Print an error message if any of the directories does not exist
  echo "One or more of the specified directories does not exist." >&2
fi
