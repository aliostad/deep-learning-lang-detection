CREATE TABLE on_time_performance (
	month VARCHAR, 
	airline_id VARCHAR, 
	carrier VARCHAR, 
	origin_city_name VARCHAR, 
	dest_city_name VARCHAR, 
	dep_delay_new numeric, 
	arr_delay_new numeric
);

COPY on_time_performance FROM '/home/vagrant/code/mks/11-24/on_time_performance.csv' DELIMITER ',' CSV HEADER;

//How many different airlines are represented in this dataset?
SELECT count(DISTINCT carrier)
FROM on_time_performance;


//Which airline had the largest quantity of delayed flights? Which had the fewest?
SELECT count(dep_delay_new) + count(arr_delay_new)
AS count, carrier
FROM on_time_performance
WHERE dep_delay_new > 0
OR arr_delay_new > 0
GROUP BY carrier
ORDER BY count DESC;


//Which departing airport had the highest number of delayed flights? Which had the fewest?
SELECT count(dep_delay_new), origin_city_name
FROM on_time_performance
WHERE dep_delay_new > 0
GROUP BY origin_city_name
ORDER BY count DESC;


//Which arriving airport had the highest number of delayed flights? Which had the fewest?
SELECT count(arr_delay_new), dest_city_name
FROM on_time_performance
WHERE arr_delay_new > 0
GROUP BY dest_city_name
ORDER BY count DESC;


//What was the average number of minutes late across all airlines?
SELECT AVG(dep_delay_new) AS departure, AVG(arr_delay_new) AS arrival
FROM on_time_performance;


//What was the average number of minutes late for each airline?
SELECT carrier, AVG(dep_delay_new) AS departure, AVG(arr_delay_new) AS arrival
FROM on_time_performance
GROUP BY carrier;

