CREATE VIEW view_payments_customers_uncreated AS
  SELECT USER, customer_id FROM users
  LEFT JOIN payments_customers USING (USER)
  WHERE customer_id IS NULL;
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
