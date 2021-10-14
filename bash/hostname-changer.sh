#!/bin/bash
#
# Harpreet Kaur - 200457019

echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+'
echo 'Harpreet Kaur : BASH LAB 2'
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+'

# Saving Hostname in Variable
varHostName=$(hostname)

# Printing hostname variable
echo 'Your Current hostname is ' $varHostName

# Reading Student Number using prompt
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+'
read -p 'Enter your student number to change hostname: ' varStudentNumber

# Concatinating Student Number with 'pc'
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+' 
newHostName=pc$varStudentNumber

# Changing Hostname in etc/hosts and '&&' printing what I have done if command runs successfully
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+' 
sudo sed -i "s/$varHostName/$newHostName/" /etc/hosts  && echo "Changed your hostname from $varHostName to $newHostName"

# Checking if the hostname is changed or not, else changing and printing
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+' 
if [[ $(hostname) != $newHostName ]] ; then 
  hostnamectl set-hostname $newHostName && echo "Changed hostname using hostnamectl command"
fi
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+' 