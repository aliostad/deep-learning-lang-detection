CREATE OR REPLACE VIEW kmdata.vw_UserPreferredNames AS
SELECT id, user_id, prefix, first_name, middle_name, last_name, suffix, 
       preferred_publishing_name, email, fax, phone, address, address_2, 
       city, state, zip, country, subscribe, url, cip_area, cip_focus, 
       prefix_show_ind, first_name_show_ind, middle_name_show_ind, last_name_show_ind, 
       suffix_show_ind, email_show_ind, url_show_ind, phone_show_ind, 
       fax_show_ind, address_1_show_ind, address_2_show_ind, city_show_ind, 
       state_show_ind, zip_show_ind, country_show_ind, resource_id, 
       created_at, updated_at
  FROM kmdata.user_preferred_names;
