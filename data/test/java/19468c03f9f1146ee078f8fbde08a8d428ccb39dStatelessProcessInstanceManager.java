package org.jbpm.samarjit;

import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.drools.runtime.process.ProcessInstance;
import org.jbpm.process.instance.ProcessInstanceManager;
import org.jbpm.samarjit.dao.WorkflowDAO;

public class StatelessProcessInstanceManager implements ProcessInstanceManager{
	private Map<Long, ProcessInstance> processInstances = new HashMap<Long, ProcessInstance>();
    private int processCounter = 0;
    private ProcessInstance lastExecutedProcessInstance = null;
    public void addProcessInstance(ProcessInstance processInstance) {
    	processCounter = WorkflowDAO.getNextId();
        ((StatelessProcessInstance) processInstance).setId(processCounter); //++processCounter
        internalAddProcessInstance(processInstance);
    }
    
    public void addProcessInstanceWithOldId(ProcessInstance processInstance) {
        internalAddProcessInstance(processInstance);
    }
    
    public void internalAddProcessInstance(ProcessInstance processInstance) {
    	lastExecutedProcessInstance = processInstance;
    	processInstances.put(((ProcessInstance)processInstance).getId(), processInstance);
    }

    public Collection<ProcessInstance> getProcessInstances() {
    	return processInstances.values();
    	//this commented as it will get changed during process instance restart
//        return Collections.unmodifiableCollection(processInstances.values()); 
    }

    public ProcessInstance getProcessInstance(long id) {
    	if(processInstances.isEmpty()){
    		System.out.println("Accessing ProcessInstance after process ended!");
    		return lastExecutedProcessInstance;
    	}
    	return (ProcessInstance) processInstances.get(id);
    }

    public void removeProcessInstance(ProcessInstance processInstance) {
        internalRemoveProcessInstance(processInstance);
    }

    public void internalRemoveProcessInstance(ProcessInstance processInstance) {
        processInstances.remove(((ProcessInstance)processInstance).getId());
        System.out.println("ProcessInstance getting removed");
    }
    
    public void clearProcessInstances() {
    	processInstances.clear();
    	System.out.println("Clearing processInstance");
    }
}
