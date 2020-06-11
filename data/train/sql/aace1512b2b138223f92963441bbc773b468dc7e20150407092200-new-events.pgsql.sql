CREATE TABLE new_event_draft_information (
	id SERIAL,
	site_id INTEGER NOT NULL,
	slug INTEGER NOT NULL,
	details TEXT NOT NULL,
	not_duplicate_events TEXT NULL,
	event_id INTEGER NULL,
	was_existing_event_id INTEGER NULL,
	user_account_id INTEGER NULL,
	updated_at timestamp without time zone NOT NULL,
	created_at timestamp without time zone NOT NULL,
	PRIMARY KEY(id)
);
CREATE UNIQUE INDEX new_event_draft_information_slug ON new_event_draft_information(site_id, slug);
ALTER TABLE new_event_draft_information ADD CONSTRAINT new_event_draft_information_site_id FOREIGN KEY (site_id) REFERENCES site_information(id);
ALTER TABLE new_event_draft_information ADD CONSTRAINT new_event_draft_information_event_id FOREIGN KEY (event_id) REFERENCES event_information(id);
ALTER TABLE new_event_draft_information ADD CONSTRAINT new_event_draft_information_was_existing_event_id FOREIGN KEY (was_existing_event_id) REFERENCES event_information(id);
ALTER TABLE new_event_draft_information ADD CONSTRAINT new_event_draft_information_user_account_id FOREIGN KEY (user_account_id) REFERENCES user_account_information(id);


CREATE TABLE new_event_draft_history (
  new_event_draft_id INTEGER,
  details TEXT NULL,
  details_changed SMALLINT DEFAULT '0' NOT NULL,
  not_duplicate_events TEXT NULL,
  not_duplicate_events_changed SMALLINT DEFAULT '0' NOT NULL,
	event_id INTEGER NULL,
	event_id_changed SMALLINT DEFAULT '0' NOT NULL,
	was_existing_event_id INTEGER NULL,
	was_existing_event_id_changed SMALLINT DEFAULT '0' NOT NULL,
	user_account_id INTEGER NULL,
	created_at timestamp without time zone NOT NULL,
	PRIMARY KEY (new_event_draft_id, created_at)
);

ALTER TABLE new_event_draft_history ADD CONSTRAINT new_event_draft_history_new_event_draft_id FOREIGN KEY (new_event_draft_id) REFERENCES new_event_draft_information(id);
ALTER TABLE new_event_draft_history ADD CONSTRAINT new_event_draft_history_event_id FOREIGN KEY (event_id) REFERENCES event_information(id);
ALTER TABLE new_event_draft_history ADD CONSTRAINT new_event_draft_history_was_existing_event_id FOREIGN KEY (was_existing_event_id) REFERENCES event_information(id);
ALTER TABLE new_event_draft_history ADD CONSTRAINT new_event_draft_history_user_account_id FOREIGN KEY (user_account_id) REFERENCES user_account_information(id);

