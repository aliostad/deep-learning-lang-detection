#!/bin/bash

#Stuff
SAVE_DIR=$1
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
white='\033[1;37m'
yellow='\033[1;33m'
NC='\033[0m' # No Color

#Variables
WHO='whoami'
UNAME='uname -mrs'

#Services / applicaties
SSH='ssh -V'
APACHE='apache2 --version'
MYSQL='mysql -V'
PHP='PHP -v'
SAMBA='smbc -V'
SNORT='snort -V'

#Custom commands, produce output error. Errors can be ignored.
FTP='dpkg -l | grep -i ftp'
TELNET='dpkg -l | grep telnet'

#General stuff
echo ""
echo -e "${green}Script wordt uitgevoerd..."
echo "Moment..."
echo ""
echo -e "${yellow}The following modules are installed:${green} "

#-------------- -----Header information----------------------#
echo "Apps & service information" >> $SAVE_DIR/.appsInfo.txt
$WHO >> $SAVE_DIR/.appsInfo.txt
$UNAME >> $SAVE_DIR/.appsInfo.txt
echo "--------------------------------------------------" >> $SAVE_DIR/.appsInfo.txt
echo "--------------------------------------------------" >> $SAVE_DIR/.appsInfo.txt


#---------------------General commands-----------------------#
# SSH
  echo "" >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  echo $SSH " OUTPUT: " >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  $SSH 2>> $SAVE_DIR/.appsInfo.txt
if [ $? -eq 0 ]; then
	echo "SSH is installed"
else
	echo "SSH is not installed"
fi

# APACHE
  echo "" >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  echo $APACHE " OUTPUT: " >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  $APACHE 2>> $SAVE_DIR/.appsInfo.txt
if [ $? -eq 0 ]; then
	echo "APACHE is installed"
else
	echo "APACHE is not installed"
fi  

# MYSQL
  echo "" >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  echo $MYSQL " OUTPUT: " >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  $MYSQL 2>> $SAVE_DIR/.appsInfo.txt
if [ $? -eq 0 ]; then
	echo "MYSQL is installed"
else
	echo "MYSQL is not installed"
fi  

# PHP
  echo "" >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  echo $PHP " OUTPUT: " >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  $PHP 2>> $SAVE_DIR/.appsInfo.txt
if [ $? -eq 0 ]; then
	echo "PHP is installed"
else
	echo "PHP is not installed"
fi  

# SAMBA
  echo "" >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  echo $SAMBA " OUTPUT: " >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  $SAMBA 2>> $SAVE_DIR/.appsInfo.txt
if [ $? -eq 0 ]; then
	echo "SAMBA is installed"
else
	echo "SAMBA is not installed"
fi  

# SNORT
  echo "" >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  echo $SNORT " OUTPUT: " >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  $SNORT 2>> $SAVE_DIR/.appsInfo.txt
if [ $? -eq 0 ]; then
	echo "SNORT is installed"
else
	echo "SNORT is not installed"
fi  

#---------------------Custom commands-----------------------#
echo ""
echo "Following errors can be ignored: "

echo "--------------------------------------------------"

# FTP
  echo "" >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  echo $FTP " OUTPUT: " >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  $FTP 3>&1>> $SAVE_DIR/.appsInfo.txt

# TELNET
  echo "" >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  echo $TELNET " OUTPUT: " >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  $TELNET 3>&1>> $SAVE_DIR/.appsInfo.txt

echo "--------------------------------------------------"


# ShellSchock
  echo "" >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  echo "ShellShock OUTPUT: " >> $SAVE_DIR/.appsInfo.txt
  echo "-------------------------" >> $SAVE_DIR/.appsInfo.txt
  env val='() { :;};' >> $SAVE_DIR/.appsInfo.txt

#Output shellschock command
env val='() { :;}; echo YES, Shellshock is present' bash -c "echo "
if [ $? -eq 1 ]; then
	echo -e "${red}Shellshock is present :-)"
else
	echo -e "${red}Shellshock is not present :-("
fi

echo ""

echo -e "${white}Script done! Check the appsInfo.txt${green}"

echo ""

exit 0