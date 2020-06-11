-- Table: read

-- DROP TABLE read;

CREATE TABLE read
(
  user_id integer NOT NULL, -- Who read the crumb.
  crumb_id character varying(15) NOT NULL, -- What crumb was read.
  CONSTRAINT read_pkey PRIMARY KEY (user_id, crumb_id),
  CONSTRAINT read_crumb_id_fkey FOREIGN KEY (crumb_id)
      REFERENCES crumb (crumb_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT read_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES "user" (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE read
  IS 'Store information on individual crumb''s read/unread status.';
COMMENT ON COLUMN read.user_id IS 'Who read the crumb.';
COMMENT ON COLUMN read.crumb_id IS 'What crumb was read.';
