#/usr/bin/env bash
# Save commands to a script if they're tagged with "#save"

function bashtag-save {
    # The prefix for the save tag.
    save_tag_prefix="#save:"
    # The path to the script directory where you want to save the command.
    script_path="$HOME/scripts/saved/"
    
    # Get the last command from history.
    last_cmd=`history | tail -1 | sed 's/^ *[0-9]* *//'`
    # Test to see if the command has the save tag in it.
    if [[ $last_cmd == *"$save_tag_prefix"* ]]; then
        # Set the file name of the script to the suffix of the save tag.
        script_name=`echo $last_cmd | sed -e 's/^.*#save:\(\w*\).*$/\1/'`.sh
        # Concat with path.
        script_file=$script_path$script_name
        # Write out the script.
        cat > $script_file <<EOL
#!/usr/bin/env bash
${last_cmd}
EOL
        # Make the script executable.
        chmod +x $script_file
    fi
}

