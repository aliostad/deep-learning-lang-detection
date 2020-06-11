/* RDFDB: */
SELECT * FROM rdf_zone
SELECT * FROM rdf_link WHERE right_postal_area_id IS NULL
SELECT * FROM rdf_link WHERE right_admin_place_id IS NULL
SELECT * FROM rdf_admin_place
SELECT * FROM rdf_place_zone WHERE admin_place_id = '21013384'
SELECT * FROM rdf_link_zone WHERE zone_id = 21010908

/* RDFDB: fetch link from city name */
SELECT * FROM rdf_city_poi_name WHERE name = 'Los Angeles'
SELECT * FROM rdf_city_poi_names WHERE name_id = 1440726286
SELECT * FROM rdf_city_poi WHERE poi_id = 1031365282
SELECT * FROM rdf_location WHERE location_id = 1640310
SELECT * FROM rdf_link WHERE link_id = 824370668

/* RDFDB: fetch link from post code */
SELECT * FROM rdf_postal_area WHERE postal_code = '90007'
SELECT * FROM rdf_postal_area WHERE postal_code = '91335'
SELECT * FROM rdf_link WHERE left_postal_area_id = '4035102' OR right_postal_area_id = '4035102'
/* Example */
SELECT link_id, ref_node_id, nonref_node_id
FROM rdf_link, rdf_postal_area
WHERE postal_code = '90007' AND (postal_area_id = left_postal_area_id OR postal_area_id = right_postal_area_id)

/* RDFDB: fetch tollway, speed category, fun class, truck route, direction */
SELECT link_id, functional_class, travel_direction, ramp, tollway, speed_category FROM rdf_nav_link
/* Example */
SELECT t1.link_id, t1.ref_node_id, t1.nonref_node_id, t3.functional_class, t3.travel_direction, t3.ramp, t3.tollway, t3.speed_category
FROM rdf_link t1, rdf_postal_area t2, rdf_nav_link t3
WHERE t2.postal_code = '90007'
AND (t2.postal_area_id = t1.left_postal_area_id OR t2.postal_area_id = t1.right_postal_area_id)
AND t1.link_id = t3.link_id

/* RDFDB: fetch carpool */
SELECT link_id, carpool_road FROM rdf_nav_link_attribute WHERE carpool_road IS NOT NULL
/* RDFDB: test I-110 */
SELECT * FROM rdf_nav_link_attribute WHERE link_id = 121235036
/* Example */
SELECT t4.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road
FROM
(SELECT t1.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category
FROM rdf_link t1, rdf_postal_area t2, rdf_nav_link t3
WHERE t2.postal_code = '90007'
AND (t2.postal_area_id = t1.left_postal_area_id OR t2.postal_area_id = t1.right_postal_area_id)
AND t1.link_id = t3.link_id) t4
LEFT JOIN rdf_nav_link_attribute t5
ON t4.link_id = t5.link_id

/* RDFDB: fetch name */
SELECT road_name_id, street_name FROM rdf_road_name
SELECT link_id, road_name_id FROM rdf_road_link

SELECT link_id, rdf_road_name.road_name_id, street_name FROM rdf_road_name, rdf_road_link WHERE link_id = 782860213 AND rdf_road_name.road_name_id = rdf_road_link.road_name_id

/* Example */
SELECT t8.link_id, street_name, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road
FROM
(SELECT t6.link_id, road_name_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road
FROM
(SELECT t4.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road
FROM
(SELECT t1.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category
FROM rdf_link t1, rdf_postal_area t2, rdf_nav_link t3
WHERE t2.postal_code = '90007'
AND (t2.postal_area_id = t1.left_postal_area_id OR t2.postal_area_id = t1.right_postal_area_id)
AND t1.link_id = t3.link_id) t4
LEFT JOIN rdf_nav_link_attribute t5
ON t4.link_id = t5.link_id) t6
LEFT JOIN rdf_road_link t7
ON t6.link_id = t7.link_id) t8
LEFT JOIN rdf_road_name t9
on t8.road_name_id = t9.road_name_id

/* RDFDB: fetch node */
SELECT * FROM rdf_node
SELECT node_id, lat, lon, zlevel FROM rdf_node WHERE node_id IN (211128985, 211141355)

/* RDFDB: fetch link from area */
/* Count: 252257 */
SELECT link_id, ref_node_id, nonref_node_id
FROM rdf_link, rdf_node
WHERE ref_node_id = node_id
AND lat >= 3385000 AND lat <= 3417000
AND lon >= -11847000 AND lon <= -11814000
/* Count:  */
SELECT t1.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category
FROM rdf_link t1, rdf_node t2, rdf_nav_link t3
WHERE ref_node_id = node_id
AND lat >= 3385000 AND lat <= 3417000
AND lon >= -11847000 AND lon <= -11814000
AND t1.link_id = t3.link_id
/* Example */
SELECT t8.link_id, street_name, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road
FROM
(SELECT t6.link_id, road_name_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road
FROM
(SELECT t4.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road
FROM
(SELECT t1.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category
FROM rdf_link t1, rdf_node t2, rdf_nav_link t3
WHERE ref_node_id = node_id
AND lat >= 3385000 AND lat <= 3417000
AND lon >= -11847000 AND lon <= -11814000
AND t1.link_id = t3.link_id) t4
LEFT JOIN rdf_nav_link_attribute t5
ON t4.link_id = t5.link_id) t6
LEFT JOIN rdf_road_link t7
ON t6.link_id = t7.link_id) t8
LEFT JOIN rdf_road_name t9
on t8.road_name_id = t9.road_name_id

/* RDFDB: use sign table */
SELECT * FROM rdf_sign_destination
SELECT * FROM rdf_sign_destination_trans

/* fetch carpool */
SELECT link_id FROM rdf_nav_link s1, rdf_access s2 WHERE s1.access_id = s2.access_id AND carpools = 'Y'
/* Example */
SELECT link_id, street_name, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road, carpools
FROM
(SELECT t8.link_id, street_name, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road, access_id
FROM
(SELECT t6.link_id, road_name_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road, access_id
FROM
(SELECT t4.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road, access_id
FROM
(SELECT t1.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, access_id
FROM rdf_link t1, rdf_node t2, rdf_nav_link t3
WHERE ref_node_id = node_id
AND lat >= 3385000 AND lat <= 3417000
AND lon >= -11847000 AND lon <= -11814000
AND t1.link_id = t3.link_id) t4
LEFT JOIN rdf_nav_link_attribute t5
ON t4.link_id = t5.link_id) t6
LEFT JOIN rdf_road_link t7
ON t6.link_id = t7.link_id) t8
LEFT JOIN rdf_road_name t9
ON t8.road_name_id = t9.road_name_id) t10
LEFT JOIN rdf_access t11
ON t10.access_id = t11.access_id

/* fetch express_lane */
SELECT link_id, express_lane FROM rdf_nav_link_attribute WHERE express_lane IS NOT NULL
/* Example */
SELECT link_id, street_name, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road, express_lane, carpools
FROM
(SELECT t8.link_id, street_name, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road, express_lane, access_id
FROM
(SELECT t6.link_id, road_name_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road, express_lane, access_id
FROM
(SELECT t4.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, carpool_road, express_lane, access_id
FROM
(SELECT t1.link_id, ref_node_id, nonref_node_id, functional_class, travel_direction, ramp, tollway, speed_category, access_id
FROM rdf_link t1, rdf_node t2, rdf_nav_link t3
WHERE ref_node_id = node_id
AND lat >= 3385000 AND lat <= 3417000
AND lon >= -11847000 AND lon <= -11814000
AND t1.link_id = t3.link_id) t4
LEFT JOIN rdf_nav_link_attribute t5
ON t4.link_id = t5.link_id) t6
LEFT JOIN rdf_road_link t7
ON t6.link_id = t7.link_id) t8
LEFT JOIN rdf_road_name t9
ON t8.road_name_id = t9.road_name_id) t10
LEFT JOIN rdf_access t11
ON t10.access_id = t11.access_id

/* fetch geometry */
SELECT link_id, lat, lon, zlevel FROM rdf_link_geometry ORDER BY link_id, seq_num

/* fetch carpool */
/* lane_type = 2 */
SELECT * FROM rdf_lane WHERE link_id = 121235036
SELECT lane_id, link_id, lane_travel_direction, lane_type FROM rdf_lane ORDER BY lane_number

/* fetch sign info */
SELECT * FROM rdf_sign_element
SELECT * FROM rdf_sign_destination
SELECT * FROM rdf_sign_origin
/* special case */
SELECT * FROM rdf_sign_element WHERE sign_id = 35690552
SELECT * FROM rdf_sign_destination WHERE sign_id = 35690552
SELECT * FROM rdf_sign_origin WHERE sign_id = 35690552

