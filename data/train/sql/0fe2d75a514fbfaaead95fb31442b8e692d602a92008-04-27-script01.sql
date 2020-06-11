ALTER TABLE projects ADD read_count INTEGER DEFAULT 0 NOT NULL;
ALTER TABLE projects ADD read_date TIMESTAMP(3);

CREATE TABLE projects_view (
  project_id INTEGER NOT NULL REFERENCES projects(project_id),
  user_id INTEGER NULL REFERENCES users(user_id),
  view_date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP NOT NULL
);
CREATE INDEX projects_vw_idx on projects_view(project_id);

ALTER TABLE ticket ADD read_count INTEGER DEFAULT 0 NOT NULL;
ALTER TABLE ticket ADD read_date TIMESTAMP(3);

CREATE TABLE ticket_view (
  ticketid INTEGER NOT NULL REFERENCES ticket(ticketid),
  user_id INTEGER NULL REFERENCES users(user_id),
  view_date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP NOT NULL
);
CREATE INDEX ticket_vw_idx on ticket_view(ticketid);

ALTER TABLE project_wiki ADD read_date TIMESTAMP(3);
ALTER TABLE project_news ADD read_date TIMESTAMP(3);
ALTER TABLE project_issues ADD read_date TIMESTAMP(3);
ALTER TABLE project_issues_categories ADD read_date TIMESTAMP(3);
