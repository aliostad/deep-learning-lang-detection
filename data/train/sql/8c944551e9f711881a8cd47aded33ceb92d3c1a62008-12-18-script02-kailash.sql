CREATE TABLE project_private_message (
	message_id INT IDENTITY PRIMARY KEY,
	project_id INTEGER REFERENCES projects(project_id),
	parent_id INTEGER,
	link_module_id INTEGER,
	link_item_id INTEGER,
	body TEXT,
	entered DATETIME DEFAULT CURRENT_TIMESTAMP,
	enteredby INTEGER REFERENCES users(user_id),
	read_date DATETIME,
	read_by INTEGER REFERENCES users(user_id),
	deleted_by_entered_by BIT DEFAULT 0,
	deleted_by_user_id BIT DEFAULT 0
);

CREATE INDEX prj_prvt_msg_prjt_idx ON project_private_message(project_id);
