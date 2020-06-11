--**************************************************************************************************
--**************************************************************************************************
--******************************************   firma   ******************************************
--**************************************************************************************************
--**************************************************************************************************

CREATE TABLE apex_objeto_ei_firma
-----------------------------------------------------------------------------------------------------
--: proyecto: toba
--: dump: componente
--: dump_clave_proyecto: objeto_ei_firma_proyecto
--: dump_clave_componente: objeto_ei_firma
--: dump_order_by: objeto_ei_firma
--: dump_where: ( objeto_ei_firma_proyecto = '%%' )
--: zona: objeto
--: desc:
--: historica: 0
--: version: 1.0
-----------------------------------------------------------------------------------------------------
(
   objeto_ei_firma_proyecto   	varchar(15)		NOT NULL,
   objeto_ei_firma            	int8			NOT NULL,
   ancho						varchar(10)		NULL,
   alto							varchar(10)		NULL,
   CONSTRAINT  "apex_objeto_ei_firma_pk" PRIMARY KEY ("objeto_ei_firma_proyecto","objeto_ei_firma"),
   CONSTRAINT  "apex_objeto_ei_firma_fk_objeto"  FOREIGN KEY ("objeto_ei_firma_proyecto","objeto_ei_firma") REFERENCES   "apex_objeto" ("proyecto","objeto") ON DELETE NO ACTION ON UPDATE NO ACTION DEFERRABLE INITIALLY IMMEDIATE
);
--###################################################################################################