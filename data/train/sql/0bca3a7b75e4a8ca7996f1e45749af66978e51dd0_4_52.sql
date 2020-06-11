alter table hms_new_application add column cancelled smallint not null default 0;
alter table hms_new_application add column cancelled_reason character varying(32);
alter table hms_new_application add column cancelled_on integer;
alter table hms_new_application add column cancelled_by character varying(32);

update hms_new_application set cancelled = 1, cancelled_reason = 'withdrawn', cancelled_on = 1325394000, cancelled_by = modified_on where withdrawn = 1 OR student_type = 'W';

ALTER TABLE hms_learning_communities ADD COLUMN terms_conditions text;