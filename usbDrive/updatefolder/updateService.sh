#!/bin/bash

# Make the script executable
sudo chmod +x ./timestampPost.sh

# Reload systemd to apply any changes
sudo systemctl daemon-reload

# Enable the service (assuming your service file is named update.service)
sudo systemctl enable timestamp.service

# Start the service
sudo systemctl restart timestamp.service