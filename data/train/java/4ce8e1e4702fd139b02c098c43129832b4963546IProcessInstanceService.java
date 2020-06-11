package com.hin.service;

import java.util.List;

import com.hin.domain.ProcessDefinition;
import com.hin.domain.ProcessInstance;
import com.hin.domain.ProcessList;

public interface IProcessInstanceService extends IBaseService<ProcessInstance>{
	 public ProcessInstance getProcessInstanceForUser(String userId,String processName);
	 public List<ProcessDefinition> getProcessProcessDefinitionsForUser(String userId);
	 public ProcessInstance saveProcessInstance(ProcessDefinition processDefinitionObject);
     public List<ProcessDefinition> getProcessDefinitionsForUser(String userId);
     public void updateParticipant(String id,String userId) ;
 	public List<ProcessList> getProcessListForUser(String userId);
	public ProcessInstance findByProcessName(String processName);
	public String getProcessListForUser(String userId,String processName);
}
