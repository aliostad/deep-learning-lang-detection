package org.drools.process.enterprise.processinstance;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.persistence.EntityManager;

import org.drools.WorkingMemory;
import org.drools.common.InternalRuleBase;
import org.drools.common.InternalWorkingMemory;
import org.drools.process.instance.ProcessInstance;
import org.drools.process.instance.ProcessInstanceManager;
import org.drools.process.instance.impl.ProcessInstanceImpl;

public class EJB3ProcessInstanceManager implements ProcessInstanceManager {

    private EntityManager manager;
    private WorkingMemory workingMemory;
    
    public void setEntityManager(EntityManager manager) {
        this.manager = manager;
    }
    
    public void setWorkingMemory(WorkingMemory workingMemory) {
        this.workingMemory = workingMemory;
    }
    
    public void addProcessInstance(ProcessInstance processInstance) {
        ProcessInstanceInfo processInstanceInfo = new ProcessInstanceInfo();
        processInstanceInfo.setProcessInstance(processInstance);
        manager.persist(processInstanceInfo);
        manager.flush();
        processInstance.setId(processInstanceInfo.getId());
    }

    public ProcessInstance getProcessInstance(long id) {
        ProcessInstanceInfo processInstanceInfo = manager.find(ProcessInstanceInfo.class, id);
        if (processInstanceInfo == null) {
            return null;
        }
        ProcessInstance processInstance = processInstanceInfo.getProcessInstance();
        processInstance.setProcess(((InternalRuleBase) workingMemory.getRuleBase()).getProcess(processInstance.getProcessId()));
        if (processInstance.getWorkingMemory() == null) {
            processInstance.setWorkingMemory((InternalWorkingMemory) workingMemory);
            ((ProcessInstanceImpl) processInstance).reconnect();
        }
        return processInstance;
    }

    public Collection<ProcessInstance> getProcessInstances() {
        List<ProcessInstance> result = new ArrayList<ProcessInstance>();
        List<ProcessInstanceInfo> processInstanceInfos = 
            manager.createQuery("from ProcessInstanceInfo").getResultList();
        if (processInstanceInfos != null) {
            for (ProcessInstanceInfo processInstanceInfo: processInstanceInfos) {
                result.add(processInstanceInfo.getProcessInstance());
            }
        }
        return result;
    }

    public void removeProcessInstance(ProcessInstance processInstance) {
        ProcessInstanceInfo processInstanceInfo = manager.find(ProcessInstanceInfo.class, processInstance.getId());
        if (processInstanceInfo != null) {
            manager.remove(processInstanceInfo);
        }
    }

}
