#!/bin/bash

# Function to search for .mkv files in a directory
search_for_mkv() {
    local dir="$1"
    local mkv_files=( "$dir"/*.mkv )

    if [ "${#mkv_files[@]}" -eq 0 ]; then
        echo "$dir" >> directories_without_mkv.txt
    fi

    for sub_dir in "$dir"/*; do
        if [ -d "$sub_dir" ]; then
            ((directories_processed++))
            printf "\rDirectories processed: %d" "$directories_processed"
            search_for_mkv "$sub_dir"
        fi
    done
}

# Initialize the directory counter.
directories_processed=0

# Check for the command-line argument specifying the directory.
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/your/directory"
    exit 1
fi

# Clear the output file if it already exists.
> directories_without_mkv.txt

# Start searching from the specified directory.
search_for_mkv "$1"

echo -e "\nSearch complete. Directories without .mkv files are listed in 'directories_without_mkv.txt'."
