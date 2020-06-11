--**************************************************************************************************
--**************************************************************************************************
--******************************************   codigo   ******************************************
--**************************************************************************************************
--**************************************************************************************************

CREATE TABLE apex_objeto_codigo
-----------------------------------------------------------------------------------------------------
--: proyecto: toba
--: dump: componente
--: dump_clave_proyecto: objeto_codigo_proyecto
--: dump_clave_componente: objeto_codigo
--: dump_order_by: objeto_codigo
--: dump_where: ( objeto_codigo_proyecto = '%%' )
--: zona: objeto
--: desc:
--: historica: 0
--: version: 1.0
-----------------------------------------------------------------------------------------------------
(
   objeto_codigo_proyecto   	varchar(15)		NOT NULL,
   objeto_codigo            	int8			NOT NULL,
   descripcion            	   	varchar(80)  	NULL,
   ancho						varchar(10)		NULL,
   alto							varchar(10)		NULL,
   CONSTRAINT  "apex_objeto_codigo_pk" PRIMARY KEY ("objeto_codigo_proyecto","objeto_codigo"),
   CONSTRAINT  "apex_objeto_codigo_fk_objeto"  FOREIGN KEY ("objeto_codigo_proyecto","objeto_codigo") REFERENCES   "apex_objeto" ("proyecto","objeto") ON DELETE NO ACTION ON UPDATE NO ACTION DEFERRABLE INITIALLY IMMEDIATE
);
--###################################################################################################