# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
#session_root "~/Projects/main"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "main"; then

  # Create a new window inline within session layout definition.
  #new_window "misc"

  # Load a defined window layout.
  # load_window "general"
  load_window "home"
  # load_window "tcl"
  #load_window "speedy"
  #load_window "crm"
  #load_window "btcloud"
	#load_window "nicta"
#  load_window "journal"

  # Select the default active window on session creation.
  select_window 0

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
