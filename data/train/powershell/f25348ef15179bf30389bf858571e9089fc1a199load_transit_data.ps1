[system.reflection.assembly]::LoadWithPartialName("MySql.Data")
$mysqlConn = New-Object -TypeName MySql.Data.MySqlClient.MySqlConnection
$mysqlConn.ConnectionString = "SERVER=localhost;DATABASE=transit;UID=root;PWD=root"
$mysqlConn.Open()
$MysqlQuery = New-Object -TypeName MySql.Data.MySqlClient.MySqlCommand
$MysqlQuery.Connection = $mysqlConn
# FEED INFO
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/feed_info.csv' INTO TABLE transit.feed_info FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (feed_publisher_name, feed_publisher_url, feed_lang, feed_start_date, feed_end_date, feed_version)"
$MysqlQuery.ExecuteNonQuery()

# AGENCY
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/agency.csv' INTO TABLE transit.agency FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES"
$MysqlQuery.ExecuteNonQuery()

# CALENDAR
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/calendar.csv' INTO TABLE transit.calendar FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date)"
$MysqlQuery.ExecuteNonQuery()

# CALENDAR
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/calendar_dates.csv' INTO TABLE transit.calendar_dates FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (service_id, date, exception_type)"
$MysqlQuery.ExecuteNonQuery()

# FARE ATTRIBUTES
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/fare_attributes.csv' INTO TABLE transit.fare_attributes FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (fare_id, price, currency_type, payment_method, transfers, transfer_duration)"
$MysqlQuery.ExecuteNonQuery()

# FARE RULES
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/fare_rules.csv' INTO TABLE transit.fare_rules FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (fare_id, route_id, origin_id, destination_id, contains_id)"
$MysqlQuery.ExecuteNonQuery()

# ROUTE
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/routes.csv' INTO TABLE transit.route FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (route_id, agency_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color)"
$MysqlQuery.ExecuteNonQuery()

# SHAPES
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/shapes.csv' INTO TABLE transit.shapes FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, shape_dist_traveled)"
$MysqlQuery.ExecuteNonQuery()

# STOPS
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/stops.csv' INTO TABLE transit.stops FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, stop_timezone, wheelchair_boarding)"
$MysqlQuery.ExecuteNonQuery()

# TRIPS
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/trips.csv' INTO TABLE transit.trips FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (route_id, service_id, trips_id, trip_headsign, trip_short_name, direction_id, block_id, shape_id, wheelchair_accessible, bikes_allowed)"
$MysqlQuery.ExecuteNonQuery()

# STOP TIMES
$MysqlQuery.CommandText = "LOAD DATA LOCAL INFILE 'C:/Users/Desktop/Desktop/COTA/stop_times.csv' INTO TABLE transit.stop_times FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (trip_id, arrival_time, departure_time, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled)"
$MysqlQuery.ExecuteNonQuery()
