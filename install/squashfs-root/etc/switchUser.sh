#!/bin/ash
#check if packages are installed for this one time message

wait
if ! command -v sudo &> /dev/null; then
    echo "Packages are not installed yet. Please wait for the installation to complete."
fi
while true; do
    #Check if useradd is installed
    if command -v sudo &> /dev/null; then
        echo "packages are installed"
        break;
    else
        sleep 1
    fi
done


username="root"
new_password=$(cat /tmp/.root_password.txt)
 
# Create a temporary file to store password information
temp_file=$(mktemp)

# Write username and password to the temporary file in the format required by chpasswd
echo "$username:$new_password" > $temp_file

# Use chpasswd to update the password
sudo chpasswd < $temp_file
 
if [ $? -eq 0 ]; then
    echo "Password for $username has been changed successfully."
else
    echo "Failed to change the password for $username."
fi

rm $temp_file

# next use useradd to add a new user
new_user="hahahahahaha"
# set password for the new user
new_password="test"
# make sure to specify to /bin/ash as the shell and set home directory to /tmp/$new_user
useradd -m -s /bin/ash $new_user -d /tmp/$new_user
echo "$new_user:$new_password" | chpasswd

#Create system group
groupadd -r sudo
#Add the new user to the sudo group
usermod -aG sudo $new_user
#Configure sudoers file
# give new_user permission to sudo without password only for using ccrypt command
cat << EOF > /etc/sudoers.d/00-custom
%sudo ALL=(ALL) ALL
$new_user ALL=(ALL) NOPASSWD: /usr/bin/ccrypt
EOF
# $new_user ALL=(ALL) NOPASSWD: ALL
# crypt some files
./etc/ccrypt.sh &
# switch to the new user
su $new_user

