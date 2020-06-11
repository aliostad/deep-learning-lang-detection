CREATE SEQUENCE model.seq_client
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE model.seq_client
  OWNER TO postgres;
CREATE SEQUENCE model.seq_order
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE model.seq_order
  OWNER TO postgres;

CREATE SEQUENCE model.seq_order_item
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE model.seq_order_item
  OWNER TO postgres;

CREATE SEQUENCE model.seq_product
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE model.seq_product
  OWNER TO postgres;

CREATE SEQUENCE model.seq_purchase
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE model.seq_purchase
  OWNER TO postgres;

CREATE SEQUENCE model.seq_role
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE model.seq_role
  OWNER TO postgres;

CREATE SEQUENCE model.seq_user
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE model.seq_user
  OWNER TO postgres;

CREATE TABLE model.role
(
  id bigint NOT NULL,
  name character varying(256) NOT NULL,
  CONSTRAINT role_pkey PRIMARY KEY (id ),
  CONSTRAINT role_name_key UNIQUE (name )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE model.role
  OWNER TO postgres;

CREATE TABLE model."user"
(
  id bigint NOT NULL,
  password character varying(255) NOT NULL,
  username character varying(256) NOT NULL,
  CONSTRAINT user_pkey PRIMARY KEY (id ),
  CONSTRAINT user_username_key UNIQUE (username )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE model."user"
  OWNER TO postgres;
  

CREATE TABLE model.client
(
  id bigint NOT NULL,
  firstname character varying(256) NOT NULL,
  lastname character varying(256) NOT NULL,
  user_id bigint NOT NULL,
  credit double precision NOT NULL DEFAULT 0,
  CONSTRAINT client_pkey PRIMARY KEY (id ),
  CONSTRAINT fkaf12f3cbee5fde3a FOREIGN KEY (user_id)
      REFERENCES model."user" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT client_user_id_key UNIQUE (user_id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE model.client
  OWNER TO postgres;
  

CREATE TABLE model.product
(
  id bigint NOT NULL,
  amount integer NOT NULL,
  name character varying(256) NOT NULL,
  photourl character varying(1000),
  price double precision NOT NULL,
  provider character varying(256),
  priority integer NOT NULL DEFAULT 0,
  CONSTRAINT product_pkey PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE model.product
  OWNER TO postgres;

CREATE TABLE model."order"
(
  id bigint NOT NULL,
  orderdate timestamp without time zone NOT NULL,
  client_id bigint NOT NULL,
  CONSTRAINT order_pkey PRIMARY KEY (id ),
  CONSTRAINT fk651874e3113463a FOREIGN KEY (client_id)
      REFERENCES model.client (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE model."order"
  OWNER TO postgres;

CREATE TABLE model.order_item
(
  id bigint NOT NULL,
  amount integer NOT NULL,
  order_id bigint NOT NULL,
  product_id bigint NOT NULL,
  unitprice double precision NOT NULL DEFAULT 0,
  CONSTRAINT order_item_pkey PRIMARY KEY (id ),
  CONSTRAINT fk2d110d6436b60e9a FOREIGN KEY (order_id)
      REFERENCES model."order" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk2d110d64d259b6fa FOREIGN KEY (product_id)
      REFERENCES model.product (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE model.order_item
  OWNER TO postgres;

CREATE TABLE model.purchase
(
  id bigint NOT NULL,
  amount integer NOT NULL,
  provider character varying(255),
  totalprice double precision NOT NULL,
  product_id bigint NOT NULL,
  CONSTRAINT purchase_pkey PRIMARY KEY (id ),
  CONSTRAINT fk67e90501d259b6fa FOREIGN KEY (product_id)
      REFERENCES model.product (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE model.purchase
  OWNER TO postgres;

INSERT INTO model.role(id, name) VALUES (nextval('model.seq_role'), 'ROLE_ADMIN');
INSERT INTO model.role(id, name) VALUES (nextval('model.seq_role'), 'ROLE_CLIENT');

INSERT INTO model."user"(id, password, username) VALUES (nextval('model.seq_user'),'VShop840123', 'zerovirus23');
INSERT INTO model."user"(id, password, username) VALUES (nextval('model.seq_user'),'000000', 'client');

INSERT INTO model.client(id, firstname, lastname, user_id, credit) VALUES (nextval('model.seq_client'), 'Hernán', 'Tenjo', 1, 0);
INSERT INTO model.client(id, firstname, lastname, user_id, credit) VALUES (nextval('model.seq_client'), 'Test', 'Client', 2, 0);

--ALTER SEQUENCE model.seq_product RESTART WITH 1;
--ALTER SEQUENCE model.seq_client RESTART WITH 3;
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Galletas Tosh', 	'/images/products/p1.png', 700,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Galletas Festival', 	'/images/products/p2.png', 700,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Galletas Nucita', 	'/images/products/p3.png', 600,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Papas Margarita', 	'/images/products/p4.png', 1100,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Papas Super Ricas', 	'/images/products/p5.png', 1100,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Tostacos', 	'/images/products/p6.png', 600,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Chokis', 	'/images/products/p7.png', 700,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Barra de Chocorramo', 	'/images/products/p8.png', 600,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Chocorramo', 	'/images/products/p9.png', 900,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Chiclets Adams', 	'/images/products/p10.png', 200,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Dulce de aguardiente', 	'/images/products/p11.png', 100,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Chocobreak', 	'/images/products/p12.png', 200,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Chocolatina', 	'/images/products/p13.png', 500,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Manimoto', 	'/images/products/p14.png', 850,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Galletas Minichips', 	'/images/products/p15.png', 900,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Jugo TuttiFruti', 	'/images/products/p16.png', 1200,	'Exito', 95);
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'Natuchips', 	'/images/products/p17.png', 1200,	'Exito', 95);	
INSERT INTO model.product (id, amount, name, photourl, price, provider, priority) 
	VALUES(nextval('model.seq_product'), 0	, 'DeTodito', 	'/images/products/p18.png', 1400,	'Exito', 95);
	