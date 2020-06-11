package org.jbpm.samarjit.myengine;

import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.drools.runtime.process.ProcessInstance;
import org.jbpm.samarjit.StatelessProcessInstance;


public class LwProcessInstanceManager  {
	private Map<Long, ProcessInstance> processInstances = new HashMap<Long, ProcessInstance>();
    private int processCounter = 0;

    public void addProcessInstance(ProcessInstance processInstance) {
        ((StatelessProcessInstance) processInstance).setId(++processCounter);
        internalAddProcessInstance(processInstance);
    }
    
    public void internalAddProcessInstance(ProcessInstance processInstance) {
    	processInstances.put(((ProcessInstance)processInstance).getId(), processInstance);
    }

    public Collection<ProcessInstance> getProcessInstances() {
        return Collections.unmodifiableCollection(processInstances.values());
    }

    public ProcessInstance getProcessInstance(long id) {
    	if(processInstances.isEmpty()){
    		System.out.println("Accessing ProcessInstance after process ended!");
//    		return processInstance;
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
