insert into hotel (id, name) values (1, 'Orion');
insert into hotel (id, name) values (2, 'Taj');

insert into department (id, name, hotel_id) values (1, 'Food', 1);
insert into department (id, name, hotel_id) values (2, 'Travel', 1);
insert into department (id, name, hotel_id) values (3, 'Hospitality', 1)
insert into department (id, name, hotel_id) values (4, 'Food', 2);

insert into touch_point(id, name,  department_id) values(1, 'Dining',  1);
insert into touch_point(id, name,  department_id) values(2, 'Kitchen', 1);
insert into touch_point(id, name,  department_id) values(3, 'Parking', 2);
insert into touch_point(id, name,  department_id) values(4, 'Reception', 3);

insert into user_status (id, value) values (1,'disable');
insert into user_status (id, value) values (2,'enable');

insert into user_type (id, value) values (1, 'ROLE_ADMIN');
insert into user_type (id, value) values (2, 'ROLE_MANAGER');
insert into user_type (id, value) values (3, 'ROLE_STAFF');

insert into  user(id, user_name, password, first_name, last_name, user_status_id , user_type_id, hotel_id)
                  values( 1,  'manmay', 'secret',   'Manmay', 'Mohanty',               1,            1,        1);
insert into  user(id, user_name, password, first_name, last_name, user_status_id , user_type_id, hotel_id)
                  values( 2, 'mrunmay', 'secret',  'Mrunmay', 'Mohanty',               2,            1,        1);
insert into  user(id, user_name, password, first_name, last_name, user_status_id , user_type_id, hotel_id)
                  values( 3, 'santosh', 'secret',  'Santosh', 'Kunatha',               2,           3,         1);
insert into  user(id, user_name, password, first_name, last_name, user_status_id , user_type_id, hotel_id)
                  values( 4, 'subhash', 'secret',  'Subhash',    'Goel',               2,            2,        1);

insert into user_departments (uid, did) values (1,1);
insert into user_departments (uid, did) values (1,2);
insert into user_departments (uid, did) values (1,3);
insert into user_departments (uid, did) values (2,1);
insert into user_departments (uid, did) values (2,2);

insert into user_touch_points (uid, tid) values (1, 1);
insert into user_touch_points (uid, tid) values (1, 3);
insert into user_touch_points (uid, tid) values (2, 3);



insert into itcs_system_zone (id, zone_id, zone_name) values (1,1,'Dining');
insert into itcs_system_zone (id, zone_id, zone_name) values (2,2,'Kitchen');
insert into itcs_system_zone (id, zone_id, zone_name) values (3,3,'Parking');
insert into itcs_system_zone (id, zone_id, zone_name) values (4,4,'Reception');




insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (1, 1000, 1, 1.1, 1.2, '2010-04-01 00:03:10');
insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (2, 1000, 1, 2.1, 3.2, '2010-04-01 00:03:18');
insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (3, 1000, 1, 1.1, 4.2, '2010-04-01 00:03:20');
insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (4, 1001, 1, 3.1, 5.2, '2010-04-01 00:11:00');
insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (15, 1001, 3, 3.1, 5.2, '2010-04-01 00:11:10');
insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (16, 1001, 1, 3.1, 5.2, '2010-04-01 00:11:03');



insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (5, 1002, 1, 1.7, 6.2, '2010-04-01 00:05:00');

insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (6, 1003, 2, 8.1, 4.2, '2010-04-02 00:00:00');
-- insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (7, 1004, 2, 5.1, 3.2, '2010-04-01 00:00:00');

-- insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (8, 1005, 3, 9.1, 9.2, '2010-04-01 00:00:00');

insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (9, 1000, 2, 1.14, 1.24, '2010-04-01 00:08:05');
insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (10, 1000, 2, 1.88, 1.29, '2010-04-01 00:08:14');
insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (11, 1000, 3, 1.88, 1.29, '2010-04-01 00:08:17');
insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (12, 1000, 2, 1.88, 1.29, '2010-04-01 00:08:18');
insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (13, 1000, 3, 1.88, 1.29, '2010-04-01 00:08:22');
insert into itcs_tag_read (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (14, 1000, 4, 1.88, 1.29, '2010-04-01 00:08:21');




insert into itcs_tag_read_history (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (1, 1004, 2, 1.88, 1.29, '2010-04-01 00:08:21');
insert into itcs_tag_read_history (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (2, 1004, 3, 1.88, 1.29, '2010-04-01 00:09:26');
insert into itcs_tag_read_history (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (3, 1004, 4, 1.88, 1.29, '2010-04-01 00:09:31');
insert into itcs_tag_read_history (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (4, 1005, 2, 1.88, 1.29, '2010-04-01 00:08:28');
insert into itcs_tag_read_history (id, guest_card, zone_id, x_coord_read, y_coord_read, tag_read_datetime) values (5, 1005, 3, 1.88, 1.29, '2010-04-01 00:09:21');








--insert into itcs_tag_read (id, guest_card, zone) values (9, 1006, 4);


insert into guest (id, hotel_id, first_name, dob, gender, nationality_id, passport_number, preferred_name, surname, title)
values (100, 1, 'John', '1988-04-21 00:00:00', 'Male', 'Indian', 'AZ74539', 'Joe', 'Smith', 'Mr');
insert into guest (id, hotel_id, first_name, dob, gender, nationality_id, passport_number, preferred_name, surname, title)
values (101, 1, 'Jasmine', '1978-12-3 00:00:00', 'Female', 'SouthAfrican', 'AZ74539', 'Jas', 'Roy', 'Miss');
insert into guest (id, hotel_id, first_name, dob, gender, nationality_id, passport_number, preferred_name, surname, title)
values (102, 1, 'John', '1989-01-22 00:00:00', 'Male', 'American', 'JH74535', 'John', 'Karthy', 'Mr');

insert into guest (id, hotel_id, first_name, dob, gender, nationality_id, passport_number, preferred_name, surname, title)
values (103, 1, 'Robert', '1999-04-1 00:00:00', 'Male', 'Indian', 'QP74536', 'Rob', 'Alvis', 'Mr');
insert into guest (id, hotel_id, first_name, dob, gender, nationality_id, passport_number, preferred_name, surname, title)
values (104, 1, 'Pooja', '1967-08-9 00:00:00', 'Female', 'Indian', 'XL74623', 'Poo', 'Das', 'Miss');
insert into guest (id, hotel_id, first_name, dob, gender, nationality_id, passport_number, preferred_name, surname, title)
values (105, 1, 'Shreya', '1988-07-06 00:00:00', 'Female', 'SouthAfrican', 'KQ74959', 'sree', 'Bata', 'Miss');
--insert into guest_profile_detail (id, hotel_id, first_name) values (106, 1, 'guest7');



insert into card (id, mag_stripe_no) values (1000, 'Room-001');
insert into card (id, mag_stripe_no) values (1001, 'Room-002');
insert into card (id, mag_stripe_no) values (1002, 'Room-003');
insert into card (id, mag_stripe_no) values (1003, 'Room-004');
insert into card (id, mag_stripe_no) values (1004, 'Room-005');
insert into card (id, mag_stripe_no) values (1005, 'Room-006');
-- insert into card (id, mag_stripe_no) values (1006, 'Room-007');




insert into guest_card (id, card_id, guest_id, status) values (1, 1000, 100, true);
insert into guest_card (id, card_id, guest_id, status) values (2, 1001, 101, true);
insert into guest_card (id, card_id, guest_id, status) values (3, 1002, 102, true);

insert into guest_card (id, card_id, guest_id, status) values (4, 1003, 103, true);
insert into guest_card (id, card_id, guest_id, status) values (5, 1004, 104, true);
insert into guest_card (id, card_id, guest_id, status) values (6, 1005, 105, true);
-- insert into guest_card (id, card_id, guest_id) values (7, 1006, 106);



insert into guest_stay_history (id, room_id, guest_id, arrival_time, departure_time, current_stay_indicator,  hotel_id) values (1, '999', 100, '2010-04-01 00:00:00', '2010-04-05 00:00:00', true,  1);
insert into guest_stay_history (id, room_id, guest_id, arrival_time, departure_time, current_stay_indicator,  hotel_id) values (2, '888', 101, '2010-04-02 00:00:00', '2010-04-06 00:00:00', false,  1);
insert into guest_stay_history (id, room_id, guest_id, arrival_time, departure_time, current_stay_indicator,  hotel_id) values (3, '777', 102, '2010-04-03 00:00:00', '2010-04-07 00:00:00', true,  1);

insert into guest_stay_history (id, room_id, guest_id, arrival_time, departure_time, current_stay_indicator,   hotel_id) values (4, '666', 103, '2010-04-03 00:00:00', '2010-04-07 00:00:00', false ,  1);
insert into guest_stay_history (id, room_id, guest_id, arrival_time, departure_time, current_stay_indicator,   hotel_id) values (5, '555', 104, '2010-04-03 00:00:00', '2010-04-07 00:00:00', true ,  1);
insert into guest_stay_history (id, room_id, guest_id, arrival_time, departure_time, current_stay_indicator,   hotel_id) values (6, '444', 105, '2010-04-03 00:00:00', '2010-04-07 00:00:00', true,  1);
--insert into guest_stay_history (id, room_id, guest_id, arrival_time, departure_time, guest_profile_detail_id) values (7, '333', 106, '2010-04-03 00:00:00', '2010-04-07 00:00:00', 106);







