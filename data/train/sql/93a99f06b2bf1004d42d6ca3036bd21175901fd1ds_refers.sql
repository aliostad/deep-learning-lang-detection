
-- REFERS DATABASE (separate)
-- ===============

-- All data passes through the refers node, and the references are
-- calculated here, so it is always consistent in its ordering.

-- New channel mechanism, based on a secret token value and a public
-- value derived from it using sha256.
-- In future could be sharded based on some of the sha256 value.

-- Can I unify the storage of fingerprint_content with
-- channel_content? Is this even desirable?

-- Should I add write_key next to the read_key? This would save a
-- sha256 operation at the cost of storing the text
-- write_key. Probably not, it's nice not having to story the secret
-- write key, and the sha256 cost is cheaper than disk usage, though
-- the current setup does make writes slower.


-- Just deduplicates the read_key text
CREATE TABLE read_keys (
       pkey serial, -- PRIMARY KEY;
       read_key bytea
);
CREATE INDEX read_keys_pkey ON read_keys (pkey);
CREATE INDEX read_keys_read_key ON read_keys (read_key);

-- content can be posted to multiple channels
CREATE TABLE channel_content (
       pkey serial, -- PRIMARY KEY;
       read_key integer,
       sha256 bytea -- (32) INDEX NOT NULL;
);
CREATE INDEX channel_content_pkey ON channel_content (pkey);
CREATE INDEX channel_content_read_key_sha256 ON channel_content (read_key, sha256);

-- The initial setup allows us to assign a random Write key as the
-- pair for a fingerprint Read key
-- Map from write_key -> fingerprint
-- (as opposed to the normal map of sha256)
CREATE TABLE fingerprint_alias (
       pkey serial, -- PRIMARY KEY;
       write_key bytea,
       fingerprint bytea
);
CREATE INDEX fingerprint_alias_pkey ON fingerprint_alias (pkey);
CREATE INDEX fingerprint_alias_write_key ON fingerprint_alias (write_key);
CREATE INDEX fingerprint_alias_fingerprint ON fingerprint_alias (fingerprint);

-- as above, except for looking up by fingerprint. This uses a
-- completely different mechanism, so is kept separate.
CREATE TABLE fingerprint_content (
       pkey serial, -- PRIMARY KEY;
       fingerprint_alias integer,
       sha256 bytea -- (32) INDEX NOT NULL;
);
CREATE INDEX fingerprint_content_pkey ON fingerprint_content (pkey);
CREATE INDEX fingerprint_content_fingerprint_alias_sha256 ON fingerprint_content (fingerprint_alias, sha256);
