CREATE VIEW view_users AS
  SELECT * FROM users LEFT JOIN users_uids USING (USER);
CREATE VIEW view_users_summaries AS
  SELECT
   USER,
   given_name,
   family_name,
   email,
   type
  FROM view_users ORDER BY USER;
CREATE VIEW view_users_sessions AS
    SELECT
        sid,
        USER,
        email,
        sid AS sessionid,
        type AS idtype,
        given_name,
        family_name,
        user_hash
    FROM users_sessions LEFT JOIN view_users USING (email);
CREATE VIEW view_payments_customers_uncreated AS
  SELECT USER, customer_id FROM users
  LEFT JOIN payments_customers USING (USER)
  WHERE customer_id = '';
CREATE VIEW view_payments_credit_cards AS
  SELECT provided, final_four, token, processed, payments_customers.*
  FROM payments_credit_cards
  LEFT JOIN payments_customers USING (USER);
CREATE VIEW view_payments_credit_cards_unsynced AS
  SELECT *
  FROM payments_credit_cards
  LEFT JOIN payments_customers USING (USER)
  WHERE processed=0;
CREATE VIEW view_files AS
    SELECT FILE, version, kind, original_filename, filename, filetype, filesize, fileextension, salt, token FROM files;
CREATE VIEW view_files_tokens AS
    SELECT FILE, token FROM files;
CREATE VIEW view_statistics_visits AS
  SELECT COUNT(*) FROM statistics_visits;
CREATE VIEW view_statistics_uniques AS
  SELECT ip_address FROM statistics_visits GROUP BY ip_address;
CREATE VIEW view_statistics_impressions AS
  SELECT ip_address, session, start, UNIX_TIMESTAMP( start ) AS start_ts, end, UNIX_TIMESTAMP( end ) AS end_ts, counter, UNIX_TIMESTAMP( end ) - UNIX_TIMESTAMP( start ) AS duration
  FROM statistics_impressions;
CREATE VIEW view_articles AS
    SELECT
        ARTICLE,
        articles.modified AS article_modified,
        id,
        source,
        category,
        subject,
        date,
        session,
        DATE_FORMAT( date, "%e %M %Y" ) AS hdate,
        title,
        video_type,
        video_code,
        h1,
        address,
        section,
        section_references,
        articles_info.hashed_id
    FROM articles LEFT JOIN articles_info ON (video_code=hashed_id);
CREATE VIEW view_articles_info AS
    SELECT
        hashed_id,
        modified,
        duration,
        filename,
        filetype,
        filesize,
        fileextension,
        SUBSTRING( base64, 1, 10 )
    FROM articles_info;
CREATE VIEW view_replicantdb_log AS
SELECT
  RDBLOG_ID,
  logged,
  command_name,
  command_type,
  command_duration_microsecs,
  status,
  result,
  error,
  USER,
  user_email,
  user_name,
  user_idtype,
  ipaddress,
  referrer
FROM replicantdb_log ORDER BY RDBLOG_ID;
