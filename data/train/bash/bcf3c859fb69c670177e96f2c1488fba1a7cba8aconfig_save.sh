################################################################################
# When the bin/init command is run, the config variables are collected and
# written to the config.sh file.
#
# Add in this file the code to save the custom variables to the config file.
#
# Use the `init_config_save_variable` function to save the variable to the config
# file.
#
# This function has 2 arguments:
# - The variable confg key.
# - The variable value.
#
# init_config_save_variable "CUSTOM_VARIABLE" "${INIT_CONFIG_CUSTOM_VARIABLE}"
#
################################################################################

# Save the Solr configuration
init_config_save_variable "SOLR_NAME" "${INIT_CONFIG_SOLR_NAME}"
init_config_save_variable "SOLR_HOST" "${INIT_CONFIG_SOLR_HOST}"
init_config_save_variable "SOLR_PORT" "${INIT_CONFIG_SOLR_PORT}"
init_config_save_variable "SOLR_PATH" "${INIT_CONFIG_SOLR_PATH}"

# Save the TIKA configuration
init_config_save_variable "TIKA_PATH" "${INIT_CONFIG_TIKA_PATH}"
init_config_save_variable "TIKA_FILE" "${INIT_CONFIG_TIKA_FILE}"

# Save the LDAP configuration
init_config_save_variable "LDAP_URL" "${INIT_CONFIG_LDAP_URL}"
init_config_save_variable "LDAP_API" "${INIT_CONFIG_LDAP_API}"

# Save the memcached settings.
init_config_save_variable "MEMCACHE_HOST" "${INIT_CONFIG_MEMCACHE_HOST}"
init_config_save_variable "MEMCACHE_PORT" "${INIT_CONFIG_MEMCACHE_PORT}"

# Save the migration settings.
init_config_save_variable "MIGRATION_MODULE" "${INIT_CONFIG_MIGRATION_MODULE}"
init_config_save_variable "MIGRATION_SCRIPT" "${INIT_CONFIG_MIGRATION_SCRIPT}"

init_config_save_variable "MIGRATION_HOST" "${INIT_CONFIG_MIGRATION_HOST}"
init_config_save_variable "MIGRATION_DB" "${INIT_CONFIG_MIGRATION_DB}"
init_config_save_variable "MIGRATION_USER" "${INIT_CONFIG_MIGRATION_USER}"
init_config_save_variable "MIGRATION_PASS" "${INIT_CONFIG_MIGRATION_PASS}"
init_config_save_variable "MIGRATION_FILES" "${INIT_CONFIG_MIGRATION_FILES}"