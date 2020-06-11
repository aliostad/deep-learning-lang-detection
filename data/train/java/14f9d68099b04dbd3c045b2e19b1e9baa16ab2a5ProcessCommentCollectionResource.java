package com.cbs.rest.api.process;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.activiti.engine.ActivitiIllegalArgumentException;
import org.activiti.engine.ActivitiObjectNotFoundException;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.rest.api.ActivitiUtil;
import org.activiti.rest.api.SecuredResource;
import org.restlet.resource.Get;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.cbs.persistence.domain.ProcessComment;
import com.cbs.persistence.service.ProcessCommentService;
import com.cbs.rest.api.utility.Utility;

public class ProcessCommentCollectionResource extends SecuredResource {

    ApplicationContext ctx = 
			new ClassPathXmlApplicationContext("activiti-context.xml");
	ProcessCommentService service = ctx.getBean("processCommentService",ProcessCommentService.class);
	List<ProcessComment> commentList = null;
	String currentProcessId = null;
	
	@Get
	public Map<String, List<ProcessComment>> getProcessComments() {
		if(authenticate() == false) return null;
		
		Map<String, List<ProcessComment>> processesComments = new TreeMap<String, List<ProcessComment>>();
		
		currentProcessId = getAttribute("processInstanceId");
	    if (currentProcessId == null) {
	      throw new ActivitiIllegalArgumentException("The processInstanceId cannot be null");
	    }
	    
		HistoricProcessInstance processInstance = ActivitiUtil.getHistoryService().createHistoricProcessInstanceQuery()
				.processInstanceId(currentProcessId)
				.singleResult();

		if (processInstance == null) {
			throw new ActivitiObjectNotFoundException("Process instance with id" + currentProcessId + " could not be found", ProcessInstance.class);
		}
	    
		// processId is set to top level process id
		String parentProcessId = currentProcessId;
		while(processInstance.getSuperProcessInstanceId() != null) {
			parentProcessId = processInstance.getSuperProcessInstanceId();
			processInstance = (HistoricProcessInstance)ActivitiUtil.getHistoryService()
					.createHistoricProcessInstanceQuery()
					.processInstanceId(parentProcessId)
					.singleResult();
		}
		
		traverseProcessTreeForId(parentProcessId, processesComments);
		
		commentList = service.findByProcessId(parentProcessId);
		String processTreeId = 
				Utility.getProcessDefinitionNameFromDefinitionId(processInstance.getProcessDefinitionId())
				+ "-" + parentProcessId;
		if(currentProcessId.equals(parentProcessId))
			processTreeId += "-self";
		else 
			processTreeId += "-null";
		processesComments.put(processTreeId, commentList);
		
		return processesComments;
	}
	
	private void traverseProcessTreeForId(String superProcessInstanceId, Map<String, List<ProcessComment>> processesComments) {
		List<HistoricProcessInstance> subprocesses = ActivitiUtil.getHistoryService().createHistoricProcessInstanceQuery()
																.superProcessInstanceId(superProcessInstanceId)
																.list();
		
		for (HistoricProcessInstance processInstance : subprocesses) {
			String processId = processInstance.getId();
			traverseProcessTreeForId(processId, processesComments);
			
			ProcessInstancesResponseCBS processResponse = new ProcessInstancesResponseCBS(processInstance);

			String processTreeId = processResponse.getProcessTreeId();
			processTreeId += 
					">" + Utility.getProcessDefinitionNameFromDefinitionId(processInstance.getProcessDefinitionId())
					+ "-" + processId;
			if(currentProcessId.equals(processId))
				processTreeId += "-self";
			else 
				processTreeId += "-null";
			commentList = service.findByProcessId(processId);
			processesComments.put(processTreeId, commentList);
		}
	}
	
}
