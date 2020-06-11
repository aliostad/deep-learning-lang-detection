truncate wordpress.wp_gigpress_shows;

-- SELECT w.`show_id`, w.`show_artist_id`, w.`show_venue_id`,
-- w.`show_tour_id`, w.`show_date`,
-- w.`show_multi`, w.`show_time`, w.`show_expire`, w.`show_price`, w.`show_tix_url`, w.`show_tix_phone`,
-- w.`show_ages`, w.`show_notes`, w.`show_related`, w.`show_status`, w.`show_tour_restore`,
-- w.`show_address`, w.`show_locale`, w.`show_country`, w.`show_venue`, w.`show_venue_url`, w.`show_venue_phone`

INSERT into wordpress.wp_gigpress_shows

SELECT distinct d.`date_id` show_id, d.`manufacturers_id` show_artist_id, v.venue_id show_venue_id,
      null show_tour_id, adddate(d.`date_date`, INTERVAL 4 year) show_date,
      null, '20:00' show_time, adddate(d.`date_date`, INTERVAL 49 month) show_expire, null show_price, null, null,
      null show_ages, d.`date_comment` show_notes, null, 'active' show_status, null,
      d.`date_location` show_address, d.`date_manfacturer_way` show_locale, c.countries_iso_code_2 show_country, d.`date_location` show_venue, d.date_link show_venue_url, d.date_comment show_venue_phone
FROM wordpress.dates d
LEFT JOIN wordpress.countries c on d.countries_id = c.countries_id
LEFT JOIN wordpress.wp_gigpress_venues v on v.venue_name = d.date_location and v.venue_city = d.date_city
WHERE v.venue_id is not null and d.date_date is not null and d.date_date > 0
GROUP BY d.`manufacturers_id`, d.`date_date`
ORDER BY date_id;

