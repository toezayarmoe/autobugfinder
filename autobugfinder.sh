#!/bin/bash

# Colors for output
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

# Function to display a message with progress
progress() {
    echo -e "${GREEN}$1${RESET}"
}

# Function to handle errors (non-blocking)
error() {
    echo -e "${RED}$1${RESET}"
}

# Prompt user for domain
read -p "Enter the target domain (e.g., example.com): " domain
date_time=$(date +"%Y%m%d_%H%M%S") # Get current date and time
output_dir="${date_time}_${domain}" # Format the output directory name
mkdir -p "$output_dir" # Create the directory


# Step 1: Find live assets (subdomains)
progress "Finding live assets..."
subfinder -d $domain -silent | httpx -silent -follow-redirects -mc 200 > "$output_dir/live_assets.txt" || error "Failed to find live assets."
echo $domain | haktrails subdomains | httpx -silent >> "$output_dir/live_assets.txt" || error "Failed to extract domain files."
cat $output_dir/live_assets.txt | awk '{print $1}' | sort -u | tee "$output_dir/live_urls.txt"


progress "Extracting JavaScript files..."
cat "$output_dir/live_urls.txt" | getJS --complete | grep "$doamin" |  tee  "$output_dir/js_files.txt" || error "Failed to extract JavaScript files."


progress "Extracting commented URLs from JavaScript files"
{
    # Loop through each JavaScript file, extracting URLs from comments
    while read js_file; do
        # Extract comments and URLs inside them
        curl -s "$js_file" | grep -oP '(?<=<!--)[^>]+(?=-->)' | grep -oE '\b(https?|http)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' >> "$output_dir/urls_from_comments.txt"
    done < "$output_dir/js_files.txt"
} || error "Failed to extract URLs from comments. Continuing to next step..."
if [ -s "$output_dir/urls_from_comments.txt" ]; then
    echo "No commented url found"
    rm $output_dir/urls_from_comments.txt
fi

progress "Finding URLs"
cat "$output_dir/live_urls.txt" | urlfinder --silent | tee "$output_dir/extracted_urls.txt" || error "Fail to extract Urls"

progress "Scanning for XSS..."
cat "$output_dir/extracted_urls.txt" | \
grep -vE "\.(js|jpg|jpeg|png|gif|svg|ico|css|pdf|zip|rar|exe|woff2?|ttf|mp4|mp3|json|xml|yaml)$" | \
grep -vE "/(assets|static|images|downloads|robots\.txt)$" | \
xargs -I@ dalfox url @ || error "XSS scan failed."


progress "Scanning for SQL injection..."
cat "$output_dir/live_urls.txt" | \
xargs -I@ sh -c '
    output_dir="'$output_dir'"
    waybackurls @ | gf sqli >> "$output_dir/sqli_vulnerabilities.txt"
' && \
if [ -s "$output_dir/sqli_vulnerabilities.txt" ]; then
    sqlmap -m "$output_dir/sqli_vulnerabilities.txt" --batch --random-agent --level 1
else
    error "No SQLi vulnerabilities found to scan."
fi



