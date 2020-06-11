CREATE TABLE project_private_message (
	message_id BIGSERIAL PRIMARY KEY,
	project_id BIGINT REFERENCES projects(project_id),
	parent_id BIGINT,
	link_module_id INTEGER,
	link_item_id BIGINT,
	body TEXT,
	entered TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	enteredby BIGINT REFERENCES users(user_id),
	read_date TIMESTAMP(3),
	read_by INTEGER REFERENCES users(user_id),
	deleted_by_entered_by BOOLEAN DEFAULT false,
	deleted_by_user_id BOOLEAN DEFAULT false
);

CREATE INDEX prj_prvt_msg_prjt_idx ON project_private_message(project_id);


