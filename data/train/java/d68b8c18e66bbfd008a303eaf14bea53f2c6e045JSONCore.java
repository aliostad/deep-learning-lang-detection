package com.thefieldpanama.webservices;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;

import com.thefieldpanama.services.EquipoService;
import com.thefieldpanama.services.GruposService;
import com.thefieldpanama.services.LigaService;
import com.thefieldpanama.services.PartidoService;
import com.thefieldpanama.services.PeriodoService;

/**
 * Core de los servicios web, de esta clase extienden todos los recursos
 * 
 * @author rospena
 * 
 */
public class JSONCore {
	@Autowired
	private LigaService ligaService;
	@Autowired
	private PartidoService partidoService;
	@Autowired
	private PeriodoService periodoService;
	private ObjectMapper mapper = new ObjectMapper();
	@Autowired
	private GruposService grupoService;
	@Autowired
	private EquipoService equipoService;

	public EquipoService getEquipoService() {
		return equipoService;
	}

	public void setEquipoService(EquipoService equipoService) {
		this.equipoService = equipoService;
	}

	public LigaService getLigaService() {
		return ligaService;
	}

	public void setLigaService(LigaService ligaService) {
		this.ligaService = ligaService;
	}

	public ObjectMapper getMapper() {
		return mapper;
	}

	public void setMapper(ObjectMapper mapper) {
		this.mapper = mapper;
	}

	public PartidoService getPartidoService() {
		return partidoService;
	}

	public void setPartidoService(PartidoService partidoService) {
		this.partidoService = partidoService;
	}

	public PeriodoService getPeriodoService() {
		return periodoService;
	}

	public void setPeriodoService(PeriodoService periodoService) {
		this.periodoService = periodoService;
	}

	public GruposService getGrupoService() {
		return grupoService;
	}

	public void setGrupoService(GruposService grupoService) {
		this.grupoService = grupoService;
	}
}
