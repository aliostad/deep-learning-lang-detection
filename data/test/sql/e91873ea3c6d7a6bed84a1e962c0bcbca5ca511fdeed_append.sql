CREATE TABLE IF NOT EXISTS [DEED_APPEND_TABLE]
  SELECT
    d.property_address, d.mail_address, d.mail_city, d.mail_state, d.owner_1_label_name,
    d.assd_total_value, d.mkt_total_value,
    c.phone_number_2,
    c.dwelling_unit_size,
    c.dwelling_type, 
    c.activity_date,
    c.dwelling_type,
    c.est_household_income_v5,
    c.ncoa_move_update_code,
    c.ncoa_move_update_date,
    c.mail_responder,
    c.length_of_residence,
    c.num_persons_in_living_unit,
    c.num_adults_in_living_unit
  FROM [DEED_CLEAN_TABLE] d
  LEFT OUTER JOIN consumerview c
  ON d.property_address = c.primary_address;
