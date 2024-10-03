#!/bin/bash

# Infinite loop
while true; do
    # Get current Unix timestamp
    unix_timestamp=$(date +%s)  # Current Unix timestamp
    str_output="Hello World! $unix_timestamp"

    # Write to a shell script to set the environment variable
    echo "export helloworldpy=\"$str_output\""
    
    # Print the output to console (optional)
    echo "$str_output"
    
    # Sleep for 10 seconds
    sleep 10
done
