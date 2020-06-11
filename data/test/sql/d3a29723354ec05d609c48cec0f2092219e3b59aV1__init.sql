CREATE TABLE EQUIPMENT (
    id BIGINT NOT NULL,
    name VARCHAR (250) not null,
    description VARCHAR (250) not null,
    city_id BIGINT not null,
    city_name VARCHAR(100) not null,
    city_state VARCHAR(2) not null,
	equip_model_id BIGINT not null,
    equip_model_name varchar(255) not null,
    equip_model_code varchar(50) not null
);

ALTER TABLE EQUIPMENT
ADD CONSTRAINT EQUIPMENT_PK
PRIMARY KEY(ID);

CREATE INDEX EQUIPMENT_IDX01_CITY ON EQUIPMENT(city_name);
CREATE INDEX EQUIPMENT_IDX02_MODEL ON EQUIPMENT(equip_model_code);


insert into EQUIPMENT (id, name, description, city_id, city_name, city_state, equip_model_id, equip_model_name, equip_model_code)
        values (101, 'Equip101', 'Equip101 - R2D2 - RIO', 2, 'Rio de Janeiro', 'RJ', 1, 'Model R2D2', 'R2D2');
insert into EQUIPMENT (id, name, description, city_id, city_name, city_state, equip_model_id, equip_model_name, equip_model_code)
        values (102, 'Equip102', 'Equip102 - C3PO - Petropolis', 4, 'Petropolis', 'RJ', 2, 'Model C3PO', 'C3PO');
insert into EQUIPMENT (id, name, description, city_id, city_name, city_state, equip_model_id, equip_model_name, equip_model_code)
        values (103, 'Equip103', 'Equip103 - T800 - Petropolis', 4, 'Petropolis', 'RJ', 3, 'Model T-800', 'T-800');
insert into EQUIPMENT (id, name, description, city_id, city_name, city_state, equip_model_id, equip_model_name, equip_model_code)
        values (104, 'Equip104', 'Equip104 - T1000 - Petropolis', 4, 'Petropolis', 'RJ', 4, 'Model T-1000', 'T-1000');
insert into EQUIPMENT (id, name, description, city_id, city_name, city_state, equip_model_id, equip_model_name, equip_model_code)
        values (105, 'Equip105', 'Equip105 - T800 - Petropolis', 4, 'Petropolis', 'RJ', 3, 'Model T-800', 'T-800');
insert into EQUIPMENT (id, name, description, city_id, city_name, city_state, equip_model_id, equip_model_name, equip_model_code)
        values (106, 'Equip106', 'Equip106 - T1000 - Petropolis', 4, 'Petropolis', 'RJ', 4, 'Model T-1000', 'T-1000');
insert into EQUIPMENT (id, name, description, city_id, city_name, city_state, equip_model_id, equip_model_name, equip_model_code)
        values (107, 'Equip107', 'Equip107 - T800 - Petropolis', 4, 'Petropolis', 'RJ', 3, 'Model T-800', 'T-800');
insert into EQUIPMENT (id, name, description, city_id, city_name, city_state, equip_model_id, equip_model_name, equip_model_code)
        values (108, 'Equip108', 'Equip108 - T1000 - Petropolis', 4, 'Petropolis', 'RJ', 4, 'Model T-1000', 'T-1000');


CREATE TABLE SILO (
    id BIGINT NOT NULL,
    name varchar (100) not null,
    description varchar (250) not null,
    state varchar (2) not null
);

insert into SILO (id, name, description, state) values (2, 'Rio Silo', 'Equipments in RIO', 'RJ');
