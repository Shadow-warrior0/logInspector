#!/bin/bash

echo ""
# Check if the wordlist file argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <wordlist_file>"
    exit 1
fi
 
wordlist_file="$1"
 
# Check if the wordlist file exists
if [ ! -e "$wordlist_file" ]; then
    echo "Error: Wordlist file '$wordlist_file' not found."
    exit 1
fi


# List all available namespaces
echo "Available namespaces:"
kubectl get namespaces --no-headers=true | awk '{print $1}'

# Prompt user for namespace
read -p "Enter the desired namespace: " namespace

# List all running pods in the specified namespace
echo "Running pods in namespace $namespace:"
running_pods=($(kubectl get pods -n "$namespace" --field-selector=status.phase=Running --no-headers=true | awk '{print $1}'))
if [ ${#running_pods[@]} -eq 0 ]; then
    echo "No running pods found in the specified namespace."
    exit 1
fi

# Display the list of running pods
for pod in "${running_pods[@]}"; do
    echo "- $pod"
done

read -p "Enter keywords separated by commas or spaces (leave empty to scan all running pods): " keywords_input
# Use either commas or spaces as separators
IFS=', ' read -ra keywords <<< "$(echo "$keywords_input" | tr -s ', ' ' ')"

# Print the keywords to verify
echo "Keywords: ${keywords[@]}"

# Get the list of pods based on the user's input
if [ -z "$keywords_input" ]; then
    # If keywords are empty, scan all running pods
    selected_pods=("${running_pods[@]}")
else
    # Otherwise, scan only pods that match the keywords
    selected_pods=()
    selected_pods=$(grep -F -f <(printf "%s\n" "${keywords[@]}") <(printf "%s\n" "${running_pods[@]}"))
fi
echo "Selected pods for processing: ${selected_pods[@]}"

# Create a folder to store logs
log_folder="suspected_logs"
mkdir -p "$log_folder"
echo "Created log folder: $log_folder"

# Function to process logs for a single pod in the background
process_pod_logs() {
    for pod in ${selected_pods[@]}; do
        pod="${pod%"${pod##*[![:space:]]}"}"  # Trim trailing spaces
        echo "Getting logs for running pod: $pod"
        # Get pod logs and save lines containing matches of keywords in wordlist file
        kubectl logs "$pod" -n "$namespace" --all-containers=true | grep -i -f "$wordlist_file" > "$log_folder/$pod.log" &

        # Note: The process runs in the background, and the script continues to the next iteration
    done

    # Wait for all background processes to finish before proceeding
    wait
}

# Process logs for each pod in the background
process_pod_logs

# Rest of the script (processing logs against the wordlist, etc.) can continue here
process_logs_for_keyword() {
    keyword="$1"
    for log_file in "$log_folder"/*.log; do
        pod=$(basename "$log_file" .log)
        grep_results=$(grep -i -F "$keyword" "$log_file")
        if [ -n "$grep_results" ]; then
            echo "$grep_results" > "$log_folder/$pod-$keyword-matches.txt"
        fi
    done
}

# Function to process logs in the background for all keywords
process_logs_background() {
    for keyword in $(cat "$wordlist_file"); do
        process_logs_for_keyword "$keyword" &
    done

    # Wait for all background processes to finish before proceeding
    wait
}

# Process logs in the background for all keywords
process_logs_background
# Remove log files 
rm $log_folder/*.log

echo "Script completed. Check the '$log_folder' folder for logs and keyword matches."
######## It's Banner Time ########

message=" 🐞🐞 Keep inspecting, keep logging, and have an epic coding adventure! 🐞🐞🚀👨‍💻"
term_width=$(tput cols)
padding=$((($term_width - ${#message}) / 2))
right_padding=$((term_width - (${#message} + ${#right_corner_message}) / 2 ))
printf "%${padding}s\e[1m%s\e[0m\n" " " "$message"
printf "%${right_padding}s\e[1;31m%s\e[0m\n" " " "$right_corner_message"

##############################################################################################
