/* This query obtains the percentage of old/new authors on 2013 for each conference */

SELECT 
	conference.conference_name as conference_name,
	IFNULL(old.authors, 0) + IFNULL(new.authors, 0) as total_authors,
	IFNULL(old.authors, 0) as old_authors,
	IFNULL(new.authors, 0) as new_authors,
	IFNULL(ROUND((old.authors/(IFNULL(old.authors, 0) + IFNULL(new.authors, 0))) * 100, 2), 0) as percetange_old_authors,
	IFNULL(ROUND((new.authors/(IFNULL(old.authors, 0) + IFNULL(new.authors, 0))) * 100, 2), 0) as percetange_new_authors
FROM
	(SELECT 
		pn.source as conference_name
	FROM 
		dblp.dblp_pub_new pn
	WHERE
		pn.type='inproceedings' 
	GROUP BY
		pn.source) as conference
	LEFT JOIN
		(SELECT 
			pn.source as conference,
			COUNT(DISTINCT(man.author)) as authors
		FROM 
			dblp.dblp_authorid_ref_new airn, /* to get the author id */
			dblp.dblp_main_aliases_new man,  /* to get the main alias of the author */
			dblp.dblp_pub_new pn
		WHERE
			pn.type='inproceedings' AND airn.id = pn.id AND airn.author_id = man.author_id AND pn.year <> '2013'
		GROUP BY
			pn.source) AS old
	ON 
		conference.conference_name = old.conference
	LEFT JOIN
		(SELECT 
			pn.source as conference,
			COUNT(DISTINCT(man.author)) as authors
		FROM 
			dblp.dblp_authorid_ref_new airn, /* to get the author id */
			dblp.dblp_main_aliases_new man,  /* to get the main alias of the author */
			dblp.dblp_pub_new pn
		WHERE
			pn.type='inproceedings' AND airn.id = pn.id AND airn.author_id = man.author_id AND pn.year = '2013'
		GROUP BY
			pn.source) AS new
	ON 
		conference.conference_name = new.conference

