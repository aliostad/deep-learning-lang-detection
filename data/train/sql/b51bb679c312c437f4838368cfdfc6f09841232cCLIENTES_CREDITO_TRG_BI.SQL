** TRIGGER BEFORE UPDATE PARA BITACORA Y REPLICACION DE CLIENTES CREDITO **/
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