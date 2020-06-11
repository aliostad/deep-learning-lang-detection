SELECT p.id FROM panos p inner JOIN panos cp ON ST_DWithin(p.latlng,cp.latlng, 0)
where p.id != cp.id  order by id limit 100;

SELECT new_panos.id, old_panos.id FROM (SELECT * from panos where label is null) as new_panos inner JOIN (SELECT * from panos where label =1) as old_panos ON ST_DWithin(new_panos.latlng,old_panos.latlng, 0)
where new_panos.id != old_panos.id;

SELECT new_panos."panoID" as new_panoID, old_panos."panoID" as old_panoID, ST_ASTEXT(new_panos.latlng) as location
 FROM (SELECT * from panos where label is null) as new_panos inner JOIN (SELECT * from panos where label =1) as old_panos ON ST_DWithin(new_panos.latlng,old_panos.latlng, 0)
where new_panos."panoID" != old_panos."panoID";
