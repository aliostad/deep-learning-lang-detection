alter table product_area add group_idx nvarchar(100);
/********************************************************
update product_area set group_idx='2,15' where product_area='Garasje villa';
update product_area set group_idx='6' where product_area='Byggelement';
update product_area set group_idx='4' where product_area='Takstol';
update product_area set group_idx='5' where product_area='Garasje rekke';
/********************************************************
create table accident(
  accident_id int identity(1,1) primary key,
  registered_by nvarchar(100) not null,
  registration_date datetime not null,
  job_function_id int references job_function(job_function_id) not null,
  personal_injury int,
  accident_date datetime not null,
  accident_time nvarchar(50),
  accident_description nvarchar(4000) not null,
  accident_cause nvarchar(4000) not null,
  reported_leader int,
  reported_police int,
  reported_social_security int
);
/********************************************************
create table accident_participant(
  accident_participant_id int identity(1,1) primary key,
  accident_id int references accident(accident_id) not null,
  first_name nvarchar(100) not null,
  last_name nvarchar(100) not null,
  employee_type_id int references employee_type(employee_type_id)
);
/********************************************************
insert into application_param(param_name,param_value) values('nav_blankett','http://www.nav.no/binary?id=218149&download=true');
/********************************************************
insert into window_access(window_name) values('Ulykke');