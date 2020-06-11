#!/bin/sh

# Extension id - be sure to correct it before running the script!
save_my_tabs_id="jfddjacdkdbmgodjnanmokpalellkele"

# User name - be sure to correct it before running the script!
save_my_tabs_user="username"

# Path to the database files:
save_my_tabs_path="/home/"$save_my_tabs_user"/.config/google-chrome/Default/databases/chrome-extension_"$save_my_tabs_id"_0/"

# Cycle through the files in the db directory:
for file in `ls $save_my_tabs_path`
do
    echo "Source file: "$save_my_tabs_path$file

    # Get db name:
    name=$(sqlite3 $save_my_tabs_path$file "SELECT name FROM save_my_tabs_options")
    echo "Target file: "$name".txt"

    # Output db rows to a tab-separated file:
    sqlite3 -separator "	" $save_my_tabs_path$file "SELECT winindex, tabindex, url, title FROM save_my_tabs_records" > $name".txt"

    # Delete the original database:
    rm -f $save_my_tabs_path$file

done