	function add_system_message(time, id, message, recipient_name)
	{
		add_message_default_design(time, id, 'ChatRobot',  recipient_name, message, '', 'system_message')
	}

	function add_warning_message(time, id, message, recipient_name)
	{
		add_message_default_design(time, id, 'ChatRobot',  recipient_name, message, '', 'system_message')
	}

	function add_private_incoming_message(time, id, sender_name, recipient_name, message, message_color)
	{
		add_message_default_design(time, id, sender_name, recipient_name, message, message_color, 'private_message')
	}

	function add_private_outgoing_message(time, id, sender_name, recipient_name, message, message_color,)
	{
		add_message_default_design(time, id, sender_name,  recipient_name, message, message_color, 'private_message')
	}

	function add_common_message(time, id, sender_name, recipient_name, message, message_color, image)
	{
		add_message_default_design(time, id, sender_name, recipient_name, message, 'common_message', message_color, image)
	}
	
	function _add_user_to_panel(user)
	{
		_add_user_to_panel_default_design(user)
	}
	
