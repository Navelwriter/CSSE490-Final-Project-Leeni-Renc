#!/bin/bash
#The install for this project is very simple. It has a folder named squashfs-root and holds all of the necessary and changed files. The script will copy and replace the files in the folder squashfs-root contained before the parent folder of this script. The parent folder is /install/ so this copies the folder /install/squashfs-root/ to ../squashfs-root and replaces the files if there are any conflicts.

#!/bin/bash
#The install for this project is very simple. It has a folder named squashfs-root and holds all of the necessary and changed files. The script will copy and replace the files in the folder squashfs-root contained before the parent folder of this script. The parent folder is /install/ so this copies the folder /install/squashfs-root/ to ../squashfs-root and replaces the files if there are any conflicts.

# Check if the user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

wget http://classes.csse.rose-hulman.edu/ece497/iotgoat.tgz
tar -xzf iotgoat.tgz

#Find the squashfs second partition and extract that
echo "Finding offset with binwalk..."
OFFSET=$(binwalk ./iotgoat/IoTGoat-raspberry-pi2.img |grep -i squash | awk '{print $1}')
echo "Found offset: ${OFFSET}, extracting..."
binwalk -e --offset=$OFFSET ./iotgoat/IoTGoat-raspberry-pi2.img
cp iotgoat/_IoTGoat-raspberry-pi2.img.extracted/1C00000.squashfs ./iotgoat/iotgoat.squashfs
#Copy iotgoat/_IoTGoat-raspberry-pi2.img.extracted/squashfs-root to ../squashfs-root
cp -r iotgoat/_IoTGoat-raspberry-pi2.img.extracted/squashfs-root/ ../
#Clean up and delete the extracted files
rm -r ./iotgoat/
rm iotgoat.tgz



folder_to_copy="squashfs-root"
# the target folder is squashfs-root in the folder above the current folder using ../
target_folder="../$folder_to_copy"

# check if the folder exists
if [ -d "$target_folder" ]; then
    echo "The folder $target_folder exists."
    # This command does a chmod +x on the files inside of $folder_to_copy/etc
    chmod +x $folder_to_copy/etc/*
    chmod +x $folder_to_copy/etc/packages/install.sh
    chmod +x $folder_to_copy/etc/boot/*
    chmod +x $folder_to_copy/etc/init.d/*
    # this copies the folder $folder_to_copy/etc to $target_folder/etc and only either adds new files or replaces files that have been changed in the folder $folder_to_copy/etc
    # the -r flag is for recursive and the -v flag is for verbose so it will show the files that are being copied or replaced
    cp -rv $folder_to_copy/etc $target_folder
    # check if there is a file named iotgoat_modified.squashfs in the parent folder
    if [ -f "../iotgoat_modified.squashfs" ]; then
        echo "The file iotgoat_modified.squashfs exists."
        # remove the file iotgoat_modified.squashfs
        rm ../iotgoat_modified.squashfs
        echo "The file iotgoat_modified.squashfs has been removed."
    fi
    mksquashfs $target_folder ../iotgoat_modified.squashfs -comp xz
else
    echo "The folder $target_folder does not exist."
    echo "Please make sure the folder $target_folder exists."
fi
rm -r ../squashfs-root
