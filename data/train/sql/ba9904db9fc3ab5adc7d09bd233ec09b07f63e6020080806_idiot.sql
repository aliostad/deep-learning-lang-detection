CREATE OR REPLACE VIEW debconf.dc_view_find_person_is_an_idiot AS (
       SELECT view_person.person_id, 
              view_person.name, 
              view_person.first_name, 
              view_person.last_name,
              view_person.nickname,
              view_person.public_name,
              view_person.email,
              view_person.gender, 
              view_conference_person.reconfirmed, 
              view_conference_person.arrived,
              view_conference_person.conference_id
   FROM view_person
   LEFT OUTER JOIN view_conference_person USING (person_id)
   WHERE (NOT view_conference_person.reconfirmed OR view_conference_person.reconfirmed IS NULL)
     AND (view_conference_person.conference_id = 2 OR view_conference_person.conference_id IS NULL));
