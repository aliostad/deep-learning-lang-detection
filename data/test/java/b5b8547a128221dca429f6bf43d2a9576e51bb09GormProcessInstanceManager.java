package org.drools.gorm.processinstance;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.drools.common.InternalKnowledgeRuntime;
import org.drools.definition.process.Process;
import org.drools.gorm.GrailsIntegration;
import org.drools.gorm.session.ProcessInstanceInfo;
import org.jbpm.process.instance.ProcessInstanceManager;
import org.jbpm.process.instance.impl.ProcessInstanceImpl;
import org.drools.runtime.process.ProcessInstance;

public class GormProcessInstanceManager
	    implements
	    ProcessInstanceManager {

    private InternalKnowledgeRuntime kruntime;
    private transient Map<Long, ProcessInstance> processInstances = new ConcurrentHashMap<Long, ProcessInstance>();

    public GormProcessInstanceManager(InternalKnowledgeRuntime kruntime) {
    	this.kruntime = kruntime;
    }

    public void addProcessInstance(ProcessInstance processInstance) {
    	ProcessInstanceInfo pii = GrailsIntegration.getGormDomainService()
    	    .getNewProcessInstanceInfo((org.jbpm.process.instance.ProcessInstance) processInstance, kruntime.getEnvironment());
    	GrailsIntegration.getGormDomainService().saveDomain(pii);
    	((org.jbpm.process.instance.ProcessInstance) processInstance).setId( pii.getId() );
        pii.updateLastReadDate();
        internalAddProcessInstance(processInstance);
    }

    @Override
    public void internalAddProcessInstance(ProcessInstance processInstance) {
        processInstances.put(processInstance.getId(), processInstance);
    }

    @Override
    public ProcessInstance getProcessInstance(long id) {
    	org.jbpm.process.instance.ProcessInstance processInstance = 
    	    (org.jbpm.process.instance.ProcessInstance) processInstances.get(id);
    	if (processInstance != null) {
    		return processInstance;
    	}
    	
        ProcessInstanceInfo processInstanceInfo = GrailsIntegration
            .getGormDomainService().getProcessInstanceInfo(id, this.kruntime.getEnvironment());
        if ( processInstanceInfo == null ) {
            return null;
        }
        processInstanceInfo.updateLastReadDate();
        processInstance = 
        	processInstanceInfo.getProcessInstance(kruntime, this.kruntime.getEnvironment());
        Process process = kruntime.getKnowledgeBase().getProcess( processInstance.getProcessId() );
        if ( process == null ) {
            throw new IllegalArgumentException( "Could not find process " + processInstance.getProcessId() );
        }
        processInstance.setProcess( process );
        if ( processInstance.getKnowledgeRuntime() == null ) {
            processInstance.setKnowledgeRuntime( kruntime );
            ((ProcessInstanceImpl) processInstance).reconnect();
        }
        return processInstance;
    }

    @Override
    public Collection<ProcessInstance> getProcessInstances() {
        return Collections.unmodifiableCollection(processInstances.values());
    }

    @Override
    public void removeProcessInstance(ProcessInstance processInstance) {
    	ProcessInstanceInfo processInstanceInfo = GrailsIntegration
     		.getGormDomainService().getProcessInstanceInfo(processInstance.getId(), this.kruntime.getEnvironment());
	     if ( processInstanceInfo != null ) {
	     	GrailsIntegration.getGormDomainService().deleteDomain(processInstanceInfo);
	     }
	     internalRemoveProcessInstance(processInstance);
    }

    @Override
    public void internalRemoveProcessInstance(ProcessInstance processInstance) {
    	processInstances.remove( processInstance.getId() );
    }
    
    @Override
    public void clearProcessInstances() {
    	for (ProcessInstance processInstance: processInstances.values()) {
    		((ProcessInstanceImpl) processInstance).disconnect();
    	}
    }
}
