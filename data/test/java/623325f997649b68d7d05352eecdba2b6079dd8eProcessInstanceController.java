/* 
 * This software is in public domain worldwide, pursuant to the CC0 Public Domain Dedication. 
 * It is distributed without any warranty.  
 * See <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
package com.redhat.jbpmsample.web.controller;

import java.util.ArrayList;
import java.util.Collection;

import org.drools.runtime.process.ProcessInstance;

import com.redhat.jbpmsample.service.ProcessService;

/**
 * A regular ManagedBeans scoped in HttpSession used to wrap ProcessService
 * It is inject in ProcessController (request scope) by faces-config.xml
 * 
 * @author lazarotti
 *
 */
public class ProcessInstanceController {
	
	private ProcessService processService;
	
	private Collection<ProcessInstance> processInstances;	
	
	public ProcessInstanceController() {
		this.processService = new ProcessService(true);
		processInstances = new ArrayList<ProcessInstance>();
	}

	public ProcessService getProcessService() {
		return processService;
	}

	public void setProcessService(ProcessService processService) {
		this.processService = processService;
	}

	public Collection<ProcessInstance> getProcessInstances() {
		return processInstances;
	}

	public void setProcessInstances(Collection<ProcessInstance> processInstances) {
		this.processInstances = processInstances;
	}

}
