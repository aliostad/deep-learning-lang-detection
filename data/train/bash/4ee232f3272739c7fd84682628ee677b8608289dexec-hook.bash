# Source this file to get preexec and postexec callbacks
#
# Define your own preexec() or postexec() functions to override
# the default, empty definitions in this file.
#

# Tie into the DEBUG event to get a zsh-like preexec hook
# A more complete version at: http://glyf.livejournal.com/63106.html
preexec() { :; }    # Default empty function
postexec() { :; }   # Default empty function
preexec_invoke_exec () {
    [ -n "$COMP_LINE" ] && return  # Completing, do nothing
    preexec "$(history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g")";
}
trap 'preexec_invoke_exec' DEBUG
PROMPT_COMMAND='postexec'
