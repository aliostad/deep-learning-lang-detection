-- Go through all salesrep_to_zipcode entries using the zipcode from waukesha_new_edits
-- change salesrep_id to the new rep's id

DELETE 
	salesrep_to_zipcode
FROM
	waukesha_new_edits
INNER JOIN
	zipcode 
ON
	waukesha_new_edits.zipcode = zipcode.zipcode
INNER JOIN
	salesrep_to_zipcode
ON
	salesrep_to_zipcode.salesrepgroup_id = 2
	AND
	salesrep_to_zipcode.zipcode_id = zipcode.id


INSERT INTO
	salesrep_to_zipcode (zipcode_id, salesrep_id, salesrepgroup_id)
SELECT
	zipcode.id,
	salesrep.id,
	2
FROM
	waukesha_new_edits
INNER JOIN
	salesrep
ON
	salesrep.person = waukesha_new_edits.new_rep
INNER JOIN
	zipcode 
ON
	waukesha_new_edits.zipcode = zipcode.zipcode