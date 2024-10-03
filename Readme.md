# Linux OS usb file Autoload

The usbUpdateService.sh script can be setup as a service in order to outmaticaly seach and load files from an usb drive to a linux OS.

## Drive Requirements
Drive must be in a linux os compatible format
- For this example FAT32 was used

In the USB a checkfile.txt is used for verification purposes.

File content for update must simply be "update"

The .sh script will output process information to this file.

The content to be updated should be in the updatefolder

Tipical content for usb on usbDrive directory

## update service

### setup .service file:
    sudo nano /etc/systemd/system/update.service

### reload services:
    sudo systemctl daemon-reload

### enable services:
    sudo systemctl enable update.service

### enable services:
    sudo systemctl restart update.service

### check services:
    sudo systemctl status update.service