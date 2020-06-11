################################################################################
# Hook information for the Install script.
################################################################################

# Common hook information.
hook_info_run_load "common.sh"

# Script specific information.
hook_info_run_load "script_before.sh"
hook_info_run_load "backup.sh"
hook_info_run_load "backup_sites_default.sh"
hook_info_run_load "cleanup.sh"
hook_info_run_load "drupal_make.sh"
hook_info_run_load "restore_sites_default.sh"
hook_info_run_load "drupal_upgrade.sh"
hook_info_run_load "drupal_login.sh"
hook_info_run_load "script_after.sh"
