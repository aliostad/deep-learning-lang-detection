--**************************************************************************************************
--**************************************************************************************************
--******************************************   grafico   ******************************************
--**************************************************************************************************
--**************************************************************************************************

CREATE TABLE apex_grafico
---------------------------------------------------------------------------------------------------
--: proyecto: toba
--: dump: nucleo
--: dump_order_by: grafico
--: zona: general
--: desc: Tipo	de	grafico
--: version: 1.0
---------------------------------------------------------------------------------------------------
(	
	grafico						varchar(20)			NOT NULL,
	descripcion_corta			varchar(40)			NULL,	--NOT
	descripcion					TEXT		NOT NULL,
	parametros					TEXT				NULL,
	CONSTRAINT	"apex_tipo_grafico_pk" PRIMARY KEY ("grafico") 
);
--#################################################################################################--

CREATE TABLE apex_objeto_grafico
-----------------------------------------------------------------------------------------------------
--: proyecto: toba
--: dump: componente
--: dump_clave_proyecto: objeto_grafico_proyecto
--: dump_clave_componente: objeto_grafico
--: dump_order_by: objeto_grafico
--: dump_where: ( objeto_grafico_proyecto = '%%' )
--: zona: objeto
--: desc:
--: historica: 0
--: version: 1.0
-----------------------------------------------------------------------------------------------------
(
   objeto_grafico_proyecto   	varchar(15)		NOT NULL,
   objeto_grafico            	int8			NOT NULL,
   descripcion            	   	varchar(80)  	NULL,
   grafico						varchar(20)		NOT NULL,
   ancho						varchar(10)		NULL,
   alto							varchar(10)		NULL,
   CONSTRAINT  "apex_objeto_grafico_pk" PRIMARY KEY ("objeto_grafico_proyecto","objeto_grafico"),
   CONSTRAINT  "apex_objeto_grafico_fk_objeto"  FOREIGN KEY ("objeto_grafico_proyecto","objeto_grafico") REFERENCES   "apex_objeto" ("proyecto","objeto") ON DELETE NO ACTION ON UPDATE NO ACTION DEFERRABLE INITIALLY IMMEDIATE,
   CONSTRAINT  "apex_objeto_grafico_fk_grafico"  FOREIGN KEY ("grafico") REFERENCES "apex_grafico" ("grafico") ON DELETE NO ACTION ON UPDATE NO ACTION DEFERRABLE INITIALLY IMMEDIATE
);
--###################################################################################################