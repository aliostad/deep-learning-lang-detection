package com.bstek.bdf2.jbpm5.service;

import java.util.Map;

import org.drools.runtime.process.ProcessInstance;

/**
 * @author Jacky.gao
 * @since 2013-4-9
 */
public interface IProcessService {
	public static final String BEAN_ID="bdf2.jbpm5.processService";	
	ProcessInstance startProcess(String processId);
	ProcessInstance startProcess(String processId,String businessId);
	ProcessInstance startProcess(String processId,Map<String,Object> map);
	void abortProcessInstance(long processInstanceId);
	Map<String, Object> getProcessInstanceVariables(long processInstanceId);
	void setProcessInstanceVariables(long processInstanceId,Map<String, Object> variables);
}
