DROP TABLE IF EXISTS  sx_clientes_credito_log

CREATE TABLE SX_CLIENTES_CREDITO_LOG
(
   ID bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
   CREDITO_ID bigint NOT NULL,
   POSTFECHADO bit NOT NULL,
   CLAVE varchar(7) NOT NULL,
   CNOTA bit NOT NULL,
   DESC_ESTIMADO double,
   DIA_COBRO int NOT NULL,
   DIA_REVISION int NOT NULL,
   LINEA decimal(19,2),
   LINEA_MON varchar(3),
   NOMBRE varchar(255) NOT NULL,
   OPERADOR_CXC int,
   PLAZO int NOT NULL,
   REVISION bit NOT NULL,
   SUSP_DESCTO bit NOT NULL,
   CRED_SUSPENDIDO bit NOT NULL,
   VENCE_FACTURA bit NOT NULL,
   MODIFICADO datetime default NULL,
   TX_REPLICADO datetime default null
)
;

/** TRIGGER BEFORE UPDATE PARA BITACORA Y REPLICACION DE CLIENTES CREDITO **/
drop TRIGGER if exists CLIENTES_CREDITO_TRG_BU

CREATE TRIGGER CLIENTES_CREDITO_TRG_BU 
    BEFORE UPDATE ON SX_CLIENTES_CREDITO
    FOR EACH ROW     
    BEGIN          
            INSERT INTO SX_CLIENTES_CREDITO_LOG (
            	CREDITO_ID
            	,POSTFECHADO
            	,CLAVE,CNOTA
            	,DESC_ESTIMADO
            	,DIA_COBRO
            	,DIA_REVISION
            	,LINEA,LINEA_MON
            	,NOMBRE
            	,OPERADOR_CXC
            	,PLAZO
            	,REVISION
            	,SUSP_DESCTO
            	,CRED_SUSPENDIDO
            	,VENCE_FACTURA
            	,MODIFICADO            	
            	)
            VALUES(
            	 NEW.CREDITO_ID
            	,NEW.POSTFECHADO
	            ,NEW.CLAVE
    	        ,NEW.CNOTA
        	    ,NEW.DESC_ESTIMADO
            	,NEW.DIA_COBRO
	            ,NEW.DIA_REVISION
	            ,NEW.LINEA
	            ,NEW.LINEA_MON
	            ,NEW.NOMBRE
	            ,NEW.OPERADOR_CXC
	            ,NEW.PLAZO
	            ,NEW.REVISION
	            ,NEW.SUSP_DESCTO
	            ,NEW.CRED_SUSPENDIDO
	            ,NEW.VENCE_FACTURA
	            ,NOW()    	        
     	        );
       UPDATE SX_CLIENTES  SET MODIFICADO= NOW() WHERE CREDITO_ID=NEW.CREDITO_ID;
     END;
