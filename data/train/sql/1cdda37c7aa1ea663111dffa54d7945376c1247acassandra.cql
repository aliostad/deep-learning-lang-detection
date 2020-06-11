#basic cassandra construct

CREATE KEYSPACE ping WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': '1'
};

USE ping;

CREATE TABLE ping (
  id int,
  pingtime timestamp,
  note text,
  temp float,
  PRIMARY KEY (id, pingtime)
) WITH
  bloom_filter_fp_chance=0.010000 AND
  caching='KEYS_ONLY' AND
  comment='' AND
  dclocal_read_repair_chance=0.000000 AND
  gc_grace_seconds=864000 AND
  read_repair_chance=0.100000 AND
  replicate_on_write='true' AND
  populate_io_cache_on_flush='false' AND
  compaction={'class': 'SizeTieredCompactionStrategy'} AND
  compression={'sstable_compression': 'SnappyCompressor'};
