-- :name get-studio-classes :? :*
select * from studio_classes;

-- :name get-studio-class :? :1
select * from studio_classes
where id = :id

-- :name create-studio-class! :! :n
insert into studio_classes
(title, creator, location, start_time, end_time, description, teacher)
values (:title, :creator, :location, :start_time, :end_time, :description, :teacher)

-- :name delete-studio-class! :! :n
delete from studio_classes
where id = :id

-- :name update-performers! :! :n
update studio_classes
set performers = :performers
where id = :id

-- :name add-performer! :! :n
update studio_classes
set performers = array_append(performers, :user_id)
where id = :studio_id

-- :name remove-performer! :! :n
update studio_classes
set performers = array_remove(performers, :user_id)
where id = :studio_id

-- :name add-attendee! :! :n
update studio_classes
set attendees = array_append(attendees, :user_id)
where id = :studio_id

-- :name remove-attendee! :! :n
update studio_classes
set attendees = array_remove (performers, :user_id)
where id = :studio_id

-- :name user-studio-performance :? :*
select * from studio_classes where :user = any(performers)

-- :name user-studio-attendance :? :*
select * from studio_classes where :user = any(attendees)

-- :name number-of-performers :? :1
select array_length(performers, 1)
from studio_classes
where id = :id

-- :name number-of-attendees :? :1
select array_length(attendees, 1)
from studio_classes
where id = :id
