SUPPORTED_TMUX_VERSION="1.6"

#these tmux options contain paths to tmux resurrect save and restore scripts
resurrect_save_path_option="@resurrect-save-script-path"
resurrect_restore_path_option="@resurrect-restore-script-path"

continuum_save_interval_option="@continuum-save-interval"
continuum_save_interval_default="15"

#time when the tmux environment was last saved (unix timestamp)
last_auto_save_option="@continuum-save-last-timestamp"

continuum_counter_option="@continuum-counter"

continuum_restore_option="@continuum-restore"
continuum_restore_default="off"

continuum_restore_halt_file="${HOME}/.tmux/resurrect/no_autorestore"

continuum_boot_option="@continuum-boot"
continuum_boot_default="off"

#comma separated list of additional options for tmux auto start
continuum_boot_options_option="@continuum-boot-options"
continuum_boot_options_default=""

osx_boot_start_file_name="Tmux.Start.plist"
osx_boot_start_file_path="${HOME}/Library/LaunchAgents/${osx_boot_start_file_name}"

# vim: set ts=8 sw=4 tw=0 ft=sh :
