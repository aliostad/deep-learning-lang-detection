INSERT INTO %prefix%pages
	(name,language,content,shown_name,show_in_nav,show_in_user_nav)
	VALUES ('index.php','%language%','','%shown_index%','%show_index_in_nav%','%show_index_in_user_nav%');

INSERT INTO %prefix%pages
	(name,language,content,shown_name,show_in_nav,show_in_user_nav)
	VALUES ('users.php?action=logout','%language%','','%shown_logout%','%show_logout_in_nav%','%show_logout_in_user_nav%');

INSERT INTO %prefix%pages
	(name,language,content,shown_name,show_in_nav,show_in_user_nav)
	VALUES ('users.php?action=registerform','%language%','','%shown_registerform%','%show_registerform_in_nav%','%show_registerform_in_user_nav%');

INSERT INTO %prefix%pages
	(name,language,content,shown_name,show_in_nav,show_in_user_nav)
	VALUES ('users.php?action=sendpassword','%language%','','%shown_sendpasswordform%','%show_sendpasswordform_in_nav%','%show_sendpasswordform_in_user_nav%');

INSERT INTO %prefix%pages
	(name,language,content,shown_name,show_in_nav,show_in_user_nav)
	VALUES ('users.php?action=changeoptionsform','%language%','','%shown_changeoptionsform%','%show_changeoptionsform_in_nav%','%show_changeoptionsform_in_user_nav%');

INSERT INTO %prefix%pages
	(name,language,content,shown_name,show_in_nav,show_in_user_nav)
	VALUES ('users.php?action=viewuserlist','%language%','','%shown_viewuserlist%','%show_viewuserlist_in_nav%','%show_viewuserlist_in_user_nav%');
