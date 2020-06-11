package com.ling2.uflo.client.service;

import java.util.List;

import com.ling2.uflo.model.ProcessDefinition;
import com.ling2.uflo.model.ProcessInstance;
import com.ling2.uflo.model.variable.Variable;
import com.ling2.uflo.query.ProcessInstanceQuery;
import com.ling2.uflo.query.ProcessQuery;
import com.ling2.uflo.query.ProcessVariableQuery;
import com.ling2.uflo.service.StartProcessInfo;

/**
 * @author Jacky.gao
 * @since 2013年9月22日
 */
public interface ProcessClient {
	public static final String BEAN_ID="uflo.processClient";
	ProcessDefinition getProcessById(long processId);
	ProcessDefinition getProcessByKey(String key);
	ProcessDefinition getProcessByName(String processName);
	ProcessDefinition getProcessByName(String processName,int version);
	
	ProcessInstance startProcessById(long processId,StartProcessInfo startProcessInfo);
	
	ProcessInstance startProcessByKey(String key,StartProcessInfo startProcessInfo);
	
	ProcessInstance startProcessByName(String processName,StartProcessInfo startProcessInfo);
	
	void deleteProcessInstanceById(long processInstanceId);
	
	ProcessInstance getProcessInstanceById(long processInstanceId);
	List<Variable> getProcessVariables(long processInsanceId);
	List<Variable> getProcessVariables(ProcessInstance processInsance);
	Object getProcessVariable(String key,ProcessInstance processInstance);
	Object getProcessVariable(String key,long processInsanceId);
	
	ProcessInstanceQuery createProcessInstanceQuery();
	ProcessVariableQuery createProcessVariableQuery();
	
	ProcessQuery createProcessQuery();
	
	void deleteProcess(long processId);
	void deleteProcess(String processKey);
	void deleteProcess(ProcessDefinition processDefinition);
}
