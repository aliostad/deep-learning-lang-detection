package com.xenogears.cotizacion.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xenogears.cotizacion.repository.ConfigVariableRepository;

@Component
public class ConfigVariableService {
	
	@Autowired
	private ConfigVariableRepository configVarRepository;

	public ConfigVariableRepository getConfigVarRepository() {
		return configVarRepository;
	}
	public void setConfigVarRepository(ConfigVariableRepository configVarRepository) {
		this.configVarRepository = configVarRepository;
	}
	
	

}
