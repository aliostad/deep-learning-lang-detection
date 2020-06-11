#!/bin/bash

if [ "${__HELPER__:-}" != 'Loaded' ]; then

  __HELPER__='Loaded'

  # ---------------------------------------------------------------------------

  #
  # Function to load libraries
  #
  LOAD() {
    local var= value= file=

    var="$1"; file="$2"
    value=$( eval "echo \"\${${var}:-}\"" )

    [ -n "${value}" ] && return 1;
    if [ -f "${file}" ]; then
      . "${file}"
    else
      echo "ERROR: Unable to load ${file}"
      exit 2
    fi
    return 0;
  }

  #
  # Load libraries
  #
  SCRIPT_HELPER_DIRECTORY="${ROOTDIR}/lib/helper"
  LOAD __LIB_ASK__  "${SCRIPT_HELPER_DIRECTORY}/ask.lib.sh"
  LOAD __LIB_CLI__  "${SCRIPT_HELPER_DIRECTORY}/cli.lib.sh"
  LOAD __LIB_CONF__ "${SCRIPT_HELPER_DIRECTORY}/conf.lib.sh"

fi # Loaded

