#!/usr/bin/env bash

#testing environment
#TODO "stub" so after test we can restore original value
export TTK_LOG_DIR="./tmpLogDir";
export TTK_WRITE_DELAY="15";
rm -rf "$TTK_LOG_DIR";
mkdir -p "$TTK_LOG_DIR";



#Fake tmux output
A="my-awesome-session:time_started:my-awesome-window:my-useful-pane:my-mmand:/home/su/games:353453"


#Test path construction
A_save_command_path="$TTK_LOG_DIR/session_name/my-awesome-session/window_name/my-awesome-window/current_path//home/su/games/current_command/my-mmand/"
A_save_pane_path="$TTK_LOG_DIR/session_name/my-awesome-session/window_name/my-awesome-window/current_path//home/su/games/pane_title/my-useful-pane/"
assert "getSaveCommandPath \"$A\"" "$A_save_command_path"
assert "getSavePaneTitlePath \"$A\"" "$A_save_pane_path"

#Test direct write
saveToFile "$TTK_LOG_DIR" "55"
assert "cat \"$TTK_LOG_DIR/time_spent.log\"" "55"

#Test delayed write
file_doSaveLog "$A" 5
assert_raises "test -e \"$A_save_command_path/time_spent.log\"" 0
assert "cat \"$A_save_command_path/time_spent.log\"" "5"

file_doSaveLog "$A" 5
assert_raises "test -e \"$A_save_command_path/time_spent.log\"" 0
assert "cat \"$A_save_command_path/time_spent.log\"" "10"

file_doSaveLog "$A" 5
assert_raises "test -e \"$A_save_command_path/time_spent.log\"" 0
assert "cat \"$A_save_command_path/time_spent.log\"" "15"

assert_end "File save tests"




#TODO tests file stats
rm -rf "$TTK_LOG_DIR";
assert_end "File stats tests"
