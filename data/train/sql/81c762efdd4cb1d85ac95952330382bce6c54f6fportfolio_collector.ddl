-- To get Postgres psycopg2 to work on OSX Mavericks
-- 1) Install Postgres.app
-- 2) Append path to Postgres.app bin directory to end of $PATH in .bash_profile
-- 3) At this point running py scripts that include psycopg2 will work, but import
--    in the Python shell will not, so ...
-- 4) $ sudo ln -s /Applications/Postgres.app/Contents/Versions/9.3/lib/libssl.1.0.0.dylib /opt/local/lib/libssl.1.0.0.dylib
-- 5) $ sudo ln -s /Applications/Postgres.app/Contents/Versions/9.3/lib/libcrypto.1.0.0.dylib /opt/local/lib/libcrypto.1.0.0.dylib
-- (Anaconda) Psycopg2 in Python shell can't find and link to these dylibs that 
-- are part of Postgres distro unless there sare sym links in the fs under the same user
-- that launches the Python shell
-- 6) Use the default data directory
-- 7) createdb -h localhost
-- This gets past error where launching the db gives error 
--  psql: FATAL:  database "<USER>" does not exist

-- NOTE: Assumes these steps were done previously
-- CLI: initdb -D /Users/markweiss/Library/Application\ Support/Postgres/var-9.3 -E UTF8
-- template0 thing necessary to override default encoding of SQL_ASCII with Postgres.app
-- CLI: createdb -E UTF8 sofine_portfolio

\connect sofine_portfolio;

create table if not exists portfolio_data 
(
    updated timestamp default now(),
    key varchar(64) not null,
    attr_key varchar(64) not null,
    attr_value varchar(1024) not null,
    primary key (updated, key, attr_key)
);

