--------Region wise Industrial development--------

--Creating new employment table containing state and region columns--

CREATE TABLE employment_new(
  employee_id serial,
  class_worker varchar(50),
  wage_phour numeric(10) CHECK (wage_phour >= 0),
  industry_code varchar(50),
  occupation_code varchar(50),
  employment_status varchar(50),
  no_persons_worked numeric(2) CHECK (no_persons_worked >= 0),
  weeks_year numeric(2) CHECK (weeks_year >= 0 AND weeks_year <= 53),
  state_curr_residence varchar(50),
  curr_region varchar(10),
  PRIMARY KEY (employee_id));

  insert into employment_new(select * from employment);

--Add random states to all the employees--

update employment_new set state_curr_residence = 'Wisconsin' where employee_id <=111751 and employee_id > 111001;

update employment_new set state_curr_residence = 'Mississippi' where employee_id <=113001 and employee_id > 111751;

update employment_new set state_curr_residence = 'Virginia' where employee_id <=114501 and employee_id > 113001;

update employment_new set state_curr_residence = 'Nebraska' where employee_id <=115001 and employee_id > 114501;

update employment_new set state_curr_residence = 'Massachusetts' where employee_id <=116001 and employee_id > 115001;

update employment_new set state_curr_residence = 'Ohio' where employee_id <=117501 and employee_id > 116001;

update employment_new set state_curr_residence = 'West Virginia' where employee_id <=118001 and employee_id > 117501;

update employment_new set state_curr_residence = 'New York' where employee_id <=118751 and employee_id > 118001;

update employment_new set state_curr_residence = 'South Dakota' where employee_id <=119001 and employee_id > 118751;

update employment_new set state_curr_residence = 'District of Columbia' where employee_id <=120001 and employee_id > 119001;

update employment_new set state_curr_residence = 'Louisiana' where employee_id <=121251 and employee_id > 120001;

update employment_new set state_curr_residence = 'Alabama' where employee_id <=122001 and employee_id > 121251;

update employment_new set state_curr_residence = 'Illinois' where employee_id <=123701 and employee_id > 122001;

update employment_new set state_curr_residence = 'Texas' where employee_id <=125001 and employee_id > 123701;

update employment_new set state_curr_residence = 'Delaware' where employee_id <=126501 and employee_id > 125001;

update employment_new set state_curr_residence = 'New Hampshire' where employee_id <=127001 and employee_id > 126501;

update employment_new set state_curr_residence = 'Alaska' where employee_id <=127151 and employee_id > 127001;

update employment_new set state_curr_residence = 'Oklahoma' where employee_id <=129001 and employee_id > 127151;

update employment_new set state_curr_residence = 'New Jersey' where employee_id <=132001 and employee_id > 129001;

update employment_new set state_curr_residence = 'Vermont' where employee_id <=133251 and employee_id > 132001;

update employment_new set state_curr_residence = 'North Dakota' where employee_id <=134001 and employee_id > 133251;

update employment_new set state_curr_residence = 'Missouri' where employee_id <=134901 and employee_id > 134001;

update employment_new set state_curr_residence = 'Florida' where employee_id <=138001 and employee_id > 134901;

update employment_new set state_curr_residence = 'Iowa' where employee_id <=139171 and employee_id > 138001;

update employment_new set state_curr_residence = 'Pennsylvania' where employee_id <=141001 and employee_id > 139171;

update employment_new set state_curr_residence = 'Georgia' where employee_id <=143501 and employee_id > 141001;

update employment_new set state_curr_residence = 'Wyoming' where employee_id <=144001 and employee_id > 143501;

update employment_new set state_curr_residence = 'Montana' where employee_id <=144501 and employee_id > 144001;

update employment_new set state_curr_residence = 'Michigan' where employee_id <=145001 and employee_id > 144501;

update employment_new set state_curr_residence = 'North Carolina' where employee_id <=147501 and employee_id > 145001;

update employment_new set state_curr_residence = 'New Mexico' where employee_id <=147991 and employee_id > 147501;

update employment_new set state_curr_residence = 'South Carolina' where employee_id <=148751 and employee_id > 147991;

update employment_new set state_curr_residence = 'Oregon' where employee_id <=149001 and employee_id > 148751;

update employment_new set state_curr_residence = 'Maryland' where employee_id <=149901 and employee_id > 149001;

update employment_new set state_curr_residence = 'Connecticut' where employee_id <=150501 and employee_id > 149901;

update employment_new set state_curr_residence = 'Arizona' where employee_id <=151001 and employee_id > 150501;

update employment_new set state_curr_residence = 'Minnesota' where employee_id <=151361 and employee_id > 151001;

update employment_new set state_curr_residence = 'California' where employee_id <=154001 and employee_id > 151361;

update employment_new set state_curr_residence = 'Kentucky' where employee_id <=154441 and employee_id > 154001;

update employment_new set state_curr_residence = 'Colorado' where employee_id <=155001 and employee_id > 154441;

update employment_new set state_curr_residence = 'Utah' where employee_id <=155771 and employee_id > 155001;

update employment_new set state_curr_residence = 'Tennessee' where employee_id <=156001 and employee_id > 155771;

update employment_new set state_curr_residence = 'Nevada' where employee_id <=157001 and employee_id > 156001;

update employment_new set state_curr_residence = 'Indiana' where employee_id <=158201 and employee_id > 157001;

update employment_new set state_curr_residence = 'Kansas' where employee_id <=160001 and employee_id > 158201;

update employment_new set state_curr_residence = 'Arkansas' where employee_id <=161907 and employee_id > 160001;


--Assigning Regions to Employee relation based on the states assigned above--


update employment_new set curr_region='North' where state_curr_residence in('Ohio','District of Columbia', 'Wyoming', 'Missouri', 'Alaska', 'Vermont', 'North Dakota', 'Montana', 'Michigan', 'Minnesota');


update employment_new set curr_region='South' where state_curr_residence in ('Georgia', 'Mississippi', 'North Carolina', 'West Virginia', 'Arkansas', 'Tennessee', 'Louisiana', 'Alabama', 'Texas', 'Delaware', 'Oklahoma', 'Florida', 'Maryland', 'Kentucky', 'Virginia', 'South Carolina');


update employment_new set curr_region='East' where state_curr_residence in('Massachusetts', 'Pennsylvania', 'New York', 'New Hampshire', 'New Jersey', 'Connecticut', 'Kansas');


update employment_new set curr_region='West' where state_curr_residence in('Wisconsin', 'Idaho', 'Nebraska', 'Kansas', 'Illinois', 'South Dakota', 'Iowa', 'Indiana', 'Colorado', 'New Mexico', 'Oregon', 'Arizona', 'California', 'Utah', 'Nevada');


--Divide industries based on region:


select count(industry_code) amt,industry_code into industry_east from employment_new where curr_region ='East' group by industry_code;


select count(industry_code) amt,industry_code into industry_south from employment_new where curr_region='South' group by industry_code;


select count(industry_code) amt,industry_code into industry_north from employment_new where curr_region='North' group by industry_code;


select count(industry_code) amt,industry_code into industry_west from employment_new where curr_region='West' group by industry_code;



--Extracting count for occupation in Retail industry:


select count(occupation_code) amt,occupation_code into occupation_north from employment_new where industry_code = 'Retail trade' and trim(curr_region)='North' group by occupation_code;	

select count(occupation_code) amt,occupation_code into occupation_south from employment_new where industry_code = 'Retail trade' and trim(curr_region)='South' group by occupation_code;	

select count(occupation_code) amt,occupation_code into occupation_east from employment_new where industry_code = 'Retail trade' and trim(curr_region)='East' group by occupation_code;	

select count(occupation_code) amt,occupation_code into occupation_west from employment_new where industry_code = 'Retail trade' and trim(curr_region)='West' group by occupation_code;	


