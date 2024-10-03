#!/bin/bash

# Variables
USB_MOUNT_POINT="/media/lcfm"  # Change this to where your system mounts the USB drive
USB_LABEL="DATAB"  # Use blkid to find the UUID of your USB or label
TARGET_FOLDER="/home/lcfm/Desktop/myFolder"  # Change to your desired folder
CHECK_FILE="checkfile.txt"
EXPECTED_STRING="update"
FILE_PATH="$USB_MOUNT_POINT/$USB_LABEL/$CHECK_FILE"

# Function to unmount the USB
unmount_usb() {
    echo "Unmounting the USB drive..."
    umount "$USB_MOUNT_POINT/$USB_LABEL"
    
    if [ $? -eq 0 ]; then
        echo "USB successfully unmounted."
    else
        echo "Failed to unmount USB."
    fi
}

# Function to check for USB
check_usb() {
    # Identify the pen drive by UUID or label (replace UUID or LABEL accordingly)
    MOUNTED_USB=$(blkid | grep "$USB_LABEL")

    if [ -n "$MOUNTED_USB" ]; then
        echo "USB detected."
        return 0
    else
        echo "USB not found."
        return 1
    fi
}

# Function to verify file and content
check_file_and_content() {
    if [ -f "$FILE_PATH" ]; then
        echo "File $CHECK_FILE exists."

        # Check if file contains expected string
        if grep -q "$EXPECTED_STRING" "$FILE_PATH"; then
            echo "File content matches expected string."
            return 0
        else
            timestamp=$(date +"%Y-%m-%d %H:%M:%S")
            echo "File content does not match. At: $timestamp"  > $FILE_PATH
            echo "File content does not match. At: $timestamp"
            unmount_usb
            return 1
        fi
    else
        echo "File $CHECK_FILE not found."
        return 1
    fi
}

# Function to copy USB content to the target folder
copy_usb_content() {
    echo "Copying USB content to $TARGET_FOLDER..."
    cp -r "$USB_MOUNT_POINT/$USB_LABEL/updatefolder"/* "$TARGET_FOLDER"

    if [ $? -eq 0 ]; then
        echo "Content copied successfully."
        return 0
    else
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        echo "Failed to copy content. At: $timestamp"  > $FILE_PATH
        echo "Failed to copy content. At: $timestamp"
        unmount_usb
        return 1
    fi
}

# Run Update service script
update_service() {
    # Ensure the script is executable
    sudo chmod +x "$TARGET_FOLDER/updateService.sh"
    # Run the script
    sudo "$TARGET_FOLDER/updateService.sh"
}



# Main script execution in an infinite loop
while true; do
    # Step 1: Check if USB is present
    check_usb
    if [ $? -eq 0 ]; then
        # Step 2: Check if specific file exists and content matches
        check_file_and_content
        if [ $? -eq 0 ]; then
            # Step 3: Copy the USB content to the target folder
            copy_usb_content
            # Step 4: Update services
            update_service
            if [ $? -eq 0 ]; then
                timestamp=$(date +"%Y-%m-%d %H:%M:%S")
                echo "Update Successful at $timestamp" > $FILE_PATH
                echo "Update Successful at $timestamp"
                unmount_usb
            fi
        fi
    fi
    
    # Sleep for 5 seconds before checking again
    sleep 5
done
