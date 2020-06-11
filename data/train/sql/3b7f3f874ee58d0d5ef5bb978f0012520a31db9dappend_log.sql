
------------------------------------------------------------
-- Put schema changes here as an append-only log that update
-- SQL seen in schema.sql and functions_and_triggers.sql
------------------------------------------------------------

--
-- Prune out old/unused queries
--

-- Failed indexes for the deimplemented "Topic X was moved to Forum Y"
-- papertrail system
DROP INDEX IF EXISTS topics_moved_at_latest_post_at;
DROP INDEX IF EXISTS topics_sort_1;

-- For show-forum topics ordering
CREATE INDEX topics_order_crystal ON topics (is_sticky DESC, latest_post_at DESC);

------------------------------------------------------------
------------------------------------------------------------

CREATE TYPE convo_folder AS ENUM (
  'INBOX'
, 'STAR'
, 'ARCHIVE'
, 'TRASH'
);

ALTER TABLE convos_participants
ADD COLUMN id serial NOT NULL PRIMARY KEY
;
ALTER TABLE convos_participants
ADD COLUMN folder convo_folder NOT NULL DEFAULT 'INBOX'
;

CREATE INDEX convos_participants__folder ON convos_participants(folder);

----------------------------------------------

ALTER TABLE users
ADD COLUMN is_nuked  BOOLEAN  NOT NULL DEFAULT false
;
