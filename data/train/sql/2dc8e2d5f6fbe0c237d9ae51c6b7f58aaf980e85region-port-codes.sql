--ADD REGION CODE
INSERT INTO regions
(id, name, latitude, longitude, area_id, order_num, show_at_zoom, show_on_main_map, show_on_map)
VALUES(99800, 'Codes without labels', 0, 0, 80000, 99800, 0, false, false);

--ADD PORT CODE
INSERT INTO ports 
(id, region_id, name, latitude, longitude, order_num, show_at_zoom, show_on_main_map, show_on_voyage_map)
VALUES(99801, 99800, '???', 0, 0, 99801, 0, false, false);

--ADD PORT CODE
INSERT INTO ports 
(id, region_id, name, latitude, longitude, order_num, show_at_zoom, show_on_main_map, show_on_voyage_map)
VALUES(21699, 21600, 'Gulf Coast, port unspecifed', 29.52468, -92.67, 21699, 0, false, false);