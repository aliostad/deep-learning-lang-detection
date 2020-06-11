spool 14_updateBlob_RULE_PARAM.log

DECLARE
  TMP_BLOB BLOB := EMPTY_BLOB();
  SRC_CHUNK_01 RAW(32767);
BEGIN
  SRC_CHUNK_01 := UTL_RAW.CAST_TO_RAW('package packws.cargaterritorio

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import java.io.File;

import org.springframework.batch.core.StepExecution;

import com.everis.util.FechaUtil;
import com.bbva.batch.util.ParamUtil;

import com.bbva.batch.enums.ParameterType;
import com.bbva.batch.util.DeciderParam;

rule "101 Configurar nombre archivo"
dialect "java" 
salience 101
no-loop true
when
	paramUtil: ParamUtil()
	params: Map()
then
	org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(DeciderParam.class);

	String rutaArchivo = params.get("PB_RUTA_ARCHIVO").toString();
	String nombreArchivo = params.get("PB_NOMBRE_ARCHIVO").toString();
	String formatoFechaSufijo = params.get("PB_FORMATO_FECHA_SUFIJO").toString();
	String nroMesAnteriores = params.get("PB_MESES_ANTERIORES").toString();

	if (!rutaArchivo.endsWith("/")) {
		rutaArchivo += "/";
	}

	StringBuilder sb = new StringBuilder();
	sb.append(rutaArchivo);
	sb.append(nombreArchivo);
	sb.append(FechaUtil.formatFecha(new Date(), formatoFechaSufijo));
	sb.append(".txt");

	String filename = sb.toString();

	logger.info("filename" + filename);

	paramUtil.setObject(ParameterType.PARAM_RESOURCE, filename);

	if(paramUtil.exists(ParameterType.PARAM_WHERE)) {
		paramUtil.setObject(ParameterType.PARAM_WHERE, paramUtil.getParamAsString(ParameterType.PARAM_WHERE).replace("${mesesAnteriores}", nroMesAnteriores));
	}
end');

  UPDATE CONELE.MNTR_PARAMETRO SET BINARIO = EMPTY_BLOB() WHERE ID = 16;

  SELECT BINARIO INTO TMP_BLOB
  FROM CONELE.MNTR_PARAMETRO
  WHERE ID = 16 FOR UPDATE;
  
  DBMS_LOB.WRITEAPPEND(TMP_BLOB, UTL_RAW.LENGTH(SRC_CHUNK_01), SRC_CHUNK_01);

  UPDATE CONELE.MNTR_PARAMETRO
  SET 
    BINARIO = (SELECT BINARIO FROM CONELE.MNTR_PARAMETRO WHERE ID = 16)
  WHERE ID IN(32, 25, 41);

  COMMIT;
END;
/

spool off