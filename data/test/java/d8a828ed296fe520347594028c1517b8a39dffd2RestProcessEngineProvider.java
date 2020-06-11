package com.github.zapata.camunda.spring.boot.embedded.web;

import java.util.Set;

import org.camunda.bpm.engine.ProcessEngine;
import org.camunda.bpm.engine.ProcessEngines;
import org.camunda.bpm.engine.rest.spi.ProcessEngineProvider;

public class RestProcessEngineProvider implements ProcessEngineProvider {

	@Override
	public ProcessEngine getDefaultProcessEngine() {
		return ProcessEngines.getDefaultProcessEngine();
	}

	@Override
	public ProcessEngine getProcessEngine(String name) {
		return ProcessEngines.getProcessEngine(name);
	}

	@Override
	public Set<String> getProcessEngineNames() {
		return ProcessEngines.getProcessEngines().keySet();
	}

}
