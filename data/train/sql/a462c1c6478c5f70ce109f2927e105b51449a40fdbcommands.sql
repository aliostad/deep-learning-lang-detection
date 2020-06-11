
-- Backup scripts --
-- backup / dumps complete database including create statements
mysqldump -u lunch4you -plunch4you lunch4you > /home/lnemeth/backup/lunch4you-backup.sql

-- Reload scripts --
-- migration dumps only data, using full INSERT statements with column names
mysqldump -u lunch4you -plunch4you --complete-insert --no-create-info lunch4you > /home/lunch4you/dump.sql

-- loads data
-- test DB
mysql -u lunch4you_test -plunch4you lunch4you_test < /home/lunch4you/dump.sql
-- prod DB
mysql -u lunch4you -plunch4you lunch4you < /home/lunch4you/dump.sql



mysqldump -u lunch4you -plunch4you --complete-insert --no-create-info --disable-keys lunch4you > /home/lunch4you/dump.sql
