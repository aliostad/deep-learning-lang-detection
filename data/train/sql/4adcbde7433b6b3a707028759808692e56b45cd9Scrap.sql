new google.maps.LatLng(40.608531, -73.957395),
new google.maps.LatLng(40.609406, -73.947669),
new google.maps.LatLng(40.608856, -73.943112),
new google.maps.LatLng(40.606877, -73.940726),
new google.maps.LatLng(40.608284, -73.938015),
new google.maps.LatLng(40.609641, -73.935845),
new google.maps.LatLng(40.611152, -73.933554),
new google.maps.LatLng(40.612455, -73.931526),
new google.maps.LatLng(40.614129, -73.928932),
new google.maps.LatLng(40.614405, -73.927027),
new google.maps.LatLng(40.614655, -73.923963),
new google.maps.LatLng(40.61486, -73.920904),
new google.maps.LatLng(40.61484, -73.91957),
new google.maps.LatLng(40.616565, -73.915026),
new google.maps.LatLng(40.617191, -73.911035),
new google.maps.LatLng(40.615772, -73.90916),
new google.maps.LatLng(40.612288, -73.906697),
new google.maps.LatLng(40.609829, -73.907086),
new google.maps.LatLng(40.606711, -73.909969),
new google.maps.LatLng(40.604599, -73.913274),
new google.maps.LatLng(40.606791, -73.916037),
new google.maps.LatLng(40.612911, -73.930717),
new google.maps.LatLng(40.616113, -73.917065),
new google.maps.LatLng(40.616023, -73.9095),
new google.maps.LatLng(40.60649, -73.915772),
new google.maps.LatLng(40.608905, -73.907618),
new google.maps.LatLng(40.61207, -73.932113)

SELECT
  concat('new google.maps.LatLng(',latitude, ', ', longitude,'),') AS gps
  -- time_received,
  -- ROUND(distance_along_trip,5) AS dist_along_trip,
  -- ROUND(next_scheduled_stop_distance,5) AS nxt_sch_stop_dist,
  -- next_scheduled_stop_code,
  -- min(raw2.next_scheduled_stop_distance) AS min
FROM raw_data raw2
WHERE inferred_route_code='MTABC_B100'
  AND vehicle_code=519
  AND inferred_direction_code = 0
  -- AND time_received < '2014-08-01 19:17:35'
GROUP BY next_scheduled_stop_code
ORDER BY time_received;
