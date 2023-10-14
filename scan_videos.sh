#!/bin/bash

# Function to scan a directory for video files and check for corruption
scan_directory() {
    local dir="$1"
    local output_file="$2"
    
    for file in "$dir"/*; do
        if [[ -f "$file" ]]; then
            echo -e "Checking: $file\n" # Print the current file being checked.
            ffmpeg -v error -i "$file" -f null - 2>&1 | grep -q "error" && echo "Corrupted: $file" >> "$output_file"
        elif [[ -d "$file" ]]; then
            scan_directory "$file" "$output_file"
        fi
    done
}

# Check for the command-line argument specifying the directory.
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/your/video/directory"
    exit 1
fi

# Directory specified as a command-line argument.
video_dir="$1"

# Specify the output file for the list of corrupted files.
output_file="corrupted_videos.txt"

# Clear the output file if it already exists.
> "$output_file"

# Start scanning the specified directory and its subdirectories.
scan_directory "$video_dir" "$output_file"

echo "Scanning complete. Corrupted videos are listed in '$output_file'."
