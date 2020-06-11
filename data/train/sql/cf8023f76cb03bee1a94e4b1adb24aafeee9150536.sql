# --- !Ups

ALTER TABLE issue_event DROP CONSTRAINT IF EXISTS ck_issue_event_event_type;
ALTER TABLE issue_event ADD constraint ck_issue_event_event_type check (event_type in ('NEW_ISSUE','NEW_POSTING','ISSUE_ASSIGNEE_CHANGED','ISSUE_STATE_CHANGED','NEW_COMMENT','NEW_PULL_REQUEST','NEW_SIMPLE_COMMENT','PULL_REQUEST_STATE_CHANGED', 'ISSUE_REFERRED'));

# --- !Downs

ALTER TABLE issue_event DROP CONSTRAINT IF EXISTS ck_issue_event_event_type;
ALTER TABLE issue_event ADD CONSTRAINT ck_issue_event_event_type check (event_type in ('NEW_ISSUE','NEW_POSTING','ISSUE_ASSIGNEE_CHANGED','ISSUE_STATE_CHANGED','NEW_COMMENT','NEW_PULL_REQUEST','NEW_SIMPLE_COMMENT','PULL_REQUEST_STATE_CHANGED'));

