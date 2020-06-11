package org.jbpm.persistence.mongodb.instance;

import java.io.NotSerializableException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.drools.core.common.InternalKnowledgeRuntime;
import org.jbpm.persistence.mongodb.MongoProcessStore;
import org.jbpm.process.instance.InternalProcessRuntime;
import org.jbpm.process.instance.ProcessInstanceManager;
import org.jbpm.process.instance.impl.ProcessInstanceImpl;
import org.jbpm.process.instance.timer.TimerManager;
import org.jbpm.ruleflow.instance.RuleFlowProcessInstance;
import org.jbpm.workflow.instance.node.StateBasedNodeInstance;
import org.jbpm.workflow.instance.node.TimerNodeInstance;
import org.kie.api.definition.process.Process;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.process.ProcessInstance;
import org.kie.api.runtime.process.WorkflowProcessInstance;
import org.kie.internal.process.CorrelationKey;
import org.kie.internal.runtime.manager.InternalRuntimeManager;
import org.kie.internal.runtime.manager.context.ProcessInstanceIdContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * This is an implementation of the {@link ProcessInstanceManager} that uses MongoDB.
 */
public class MongoProcessInstanceManager implements ProcessInstanceManager {
    Logger logger = LoggerFactory.getLogger( getClass() );
	private MongoProcessStore store;

    private InternalKnowledgeRuntime kruntime;
    
    private Map<Long, MongoProcessInstanceInfo> processInstanceInfoCache = new HashMap<Long, MongoProcessInstanceInfo>(); 
    
    public void setKnowledgeRuntime(InternalKnowledgeRuntime kruntime) {
        store = (MongoProcessStore)kruntime.getEnvironment().get(MongoProcessStore.envKey);
        this.kruntime = kruntime;
    }

    public void addProcessInstance(ProcessInstance processInstance, CorrelationKey correlationKey) {
        internalAddProcessInstance(processInstance);
        MongoProcessInstanceInfo processInstanceInfo = new MongoProcessInstanceInfo(processInstance);
        if (correlationKey != null) 
        	processInstanceInfo.assignCorrelationKey(correlationKey);
        
        long procInstId = store.getNextProcessInstanceId();
        processInstanceInfo.setProcessInstanceId(procInstId);
        ((org.jbpm.process.instance.ProcessInstance) processInstance).setId( processInstanceInfo.getProcessInstanceId() );
        processInstanceInfo.setProcessId(processInstance.getProcessId());
        try {
			MongoProcessInstanceMarshaller.serialize(processInstanceInfo);
		} catch (NotSerializableException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        store.saveNew(processInstanceInfo);
        processInstanceInfoCache.put(processInstanceInfo.getProcessInstanceId(), processInstanceInfo);
    }
    
    public void internalAddProcessInstance(ProcessInstance processInstance) {
    	org.jbpm.process.instance.ProcessInstance pi = (org.jbpm.process.instance.ProcessInstance)processInstance;
        if (((ProcessInstanceImpl) pi).getProcessXml() == null) {
	        Process process = kruntime.getKieBase().getProcess( processInstance.getProcessId() );
	        if ( process == null ) {
	            throw new IllegalArgumentException( "Could not find process " + processInstance.getProcessId() );
	        }
	        pi.setProcess( process );
        }
        if ( pi.getKnowledgeRuntime() == null ) {
            Long parentProcessInstanceId = (Long) ((ProcessInstanceImpl) processInstance).getMetaData().get("ParentProcessInstanceId");
            if (parentProcessInstanceId != null) {
                kruntime.getProcessInstance(parentProcessInstanceId);
            }
            pi.setKnowledgeRuntime( kruntime );
        }
    }

    public ProcessInstance getProcessInstance(long id) {
        return getProcessInstance(id, false);
    }

	public ProcessInstance getProcessInstance(long id, boolean readOnly) {
        InternalRuntimeManager manager = (InternalRuntimeManager) kruntime.getEnvironment().get("RuntimeManager");
        if (manager != null) {
            manager.validate((KieSession) kruntime, ProcessInstanceIdContext.get(id));
        }
        MongoProcessInstanceInfo procInstInfo = findProcessInstanceInfo(id);
        return toProcessInstance(procInstInfo);
    }

	private ProcessInstance toProcessInstance(
			MongoProcessInstanceInfo procInstInfo) {
		if (procInstInfo == null)
        	return null;

		org.jbpm.process.instance.ProcessInstance processInstance = (org.jbpm.process.instance.ProcessInstance)	procInstInfo.getProcessInstance();

		if (processInstance == null) {
    		try {
				MongoProcessInstanceMarshaller.deserialize(procInstInfo, kruntime);
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		processInstance = (org.jbpm.process.instance.ProcessInstance)	procInstInfo.getProcessInstance();
		if (processInstance != null) {
        	internalAddProcessInstance(processInstance);
            if (!procInstInfo.isReconnected()) {
            	((RuleFlowProcessInstance)processInstance).reconnect();
            	procInstInfo.reconnect();
            }
        }
        return processInstance;
	}

    public Collection<ProcessInstance> getProcessInstances() {
    	processInstanceInfoCache.clear();
    	List<MongoProcessInstanceInfo> procInstInfos = store.findAllProcessInstances();
    	List<ProcessInstance> processInstances = new ArrayList<ProcessInstance>();
    	for (MongoProcessInstanceInfo procInstInfo:procInstInfos) {
    		ProcessInstance instance = toProcessInstance(procInstInfo);
    		processInstances.add(instance);
    		processInstanceInfoCache.put(procInstInfo.getProcessInstanceId(), procInstInfo);
    	}
        return Collections.unmodifiableCollection(processInstances);
    }

    public void internalRemoveProcessInstance(ProcessInstance processInstance) {
    	processInstanceInfoCache.remove(processInstance.getId());
    }
    
    public void clearProcessInstances() {
    	logger.debug("clearProcessInstances called");
    	for (MongoProcessInstanceInfo procInstInfo:processInstanceInfoCache.values()) {
    		ProcessInstance processInstance = procInstInfo.getProcessInstance();
        	if (processInstance == null) continue;
    		((ProcessInstanceImpl) processInstance).disconnect();
        }
        processInstanceInfoCache.clear();
    }

    public void clearProcessInstancesState() {
        try {
        	Collection<ProcessInstance> processInstances = getProcessInstances();
            // at this point only timers are considered as state that needs to be cleared
            TimerManager timerManager = ((InternalProcessRuntime)kruntime.getProcessRuntime()).getTimerManager();
            
            for (ProcessInstance processInstance: processInstances) {
                WorkflowProcessInstance pi = ((WorkflowProcessInstance) processInstance);
                
                for (org.kie.api.runtime.process.NodeInstance nodeInstance : pi.getNodeInstances()) {
                    if (nodeInstance instanceof TimerNodeInstance){
                        if (((TimerNodeInstance)nodeInstance).getTimerInstance() != null) {
                            timerManager.cancelTimer(((TimerNodeInstance)nodeInstance).getTimerInstance().getId());
                        }
                    } else if (nodeInstance instanceof StateBasedNodeInstance) {
                        List<Long> timerIds = ((StateBasedNodeInstance) nodeInstance).getTimerInstances();
                        if (timerIds != null) {
                            for (Long id: timerIds) {
                                timerManager.cancelTimer(id);
                            }
                        }
                    }
                }
                
            }
        } catch (Exception e) {
            // catch everything here to make sure it will not break any following 
            // logic to allow complete clean up 
        }
    }

	public ProcessInstance findProcessInstanceByWorkItemId(long workItemId, boolean readOnly) {
		MongoProcessInstanceInfo procInst = store.findProcessInstanceByWorkItemId(workItemId);
		if (procInst != null) { 
    		processInstanceInfoCache.put(procInst.getProcessInstanceId(), procInst);
			return toProcessInstance(procInst);
		} else 
			return null;
	}

	public List<ProcessInstance> findProcessInstancesByProcessEvent(String eventType) {
		List<MongoProcessInstanceInfo> mongoInstances = store.findProcessInstancesByProcessEvent(eventType);
		List<ProcessInstance> instances = new ArrayList<ProcessInstance>();
		for (MongoProcessInstanceInfo mongoInstance:mongoInstances) {
    		processInstanceInfoCache.put(mongoInstance.getProcessInstanceId(),  mongoInstance);
			instances.add(toProcessInstance(mongoInstance));
		}
		return instances;
	}
    @Override
    public ProcessInstance getProcessInstance(CorrelationKey correlationKey) {
		MongoProcessInstanceInfo procInst = store.findProcessInstanceInfoByProcessCorrelationKey(correlationKey);
		if (procInst != null) { 
    		processInstanceInfoCache.put(procInst.getProcessInstanceId(),  procInst);
    		return toProcessInstance(procInst);
		} else 
			return null;
	}

    @Override
    public void removeProcessInstance(ProcessInstance processInstance) {
    	if (processInstance == null) return;
    	long procInstId = processInstance.getId();
		store.removeProcessInstanceInfo(procInstId);
        internalRemoveProcessInstance(processInstance);
    }
    
    public MongoProcessInstanceInfo findProcessInstanceInfo(long procInstId) {
    	MongoProcessInstanceInfo procInstInfo = processInstanceInfoCache.get(procInstId);
    	if (procInstInfo == null) {
    		procInstInfo = store.findProcessInstanceInfo(procInstId);
    		if (procInstInfo == null) return null;
    		toProcessInstance(procInstInfo);
    		processInstanceInfoCache.put(procInstId,  procInstInfo);
    	}
		return procInstInfo;
    }
}
