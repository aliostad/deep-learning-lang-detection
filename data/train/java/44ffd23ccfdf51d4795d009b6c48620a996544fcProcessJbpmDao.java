package org.flexpay.common.process.dao;

import org.drools.definition.KnowledgePackage;
import org.drools.event.process.ProcessEventListener;
import org.drools.runtime.process.ProcessInstance;
import org.flexpay.common.dao.paging.Page;
import org.flexpay.common.persistence.DateRange;
import org.flexpay.common.process.filter.ProcessNameFilter;
import org.flexpay.common.process.sorter.ProcessSorter;
import org.jbpm.process.audit.ProcessInstanceLog;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface ProcessJbpmDao {
	List<org.drools.definition.process.Process> getProcesses();

	org.drools.definition.process.Process getProcess(String processId);

	org.drools.definition.process.Process getProcessByName(String name);

	void addPackages(Collection<KnowledgePackage> packages);

	void removeProcess(String processId);

	List<ProcessInstanceLog> getProcessInstanceLogs();

	ProcessInstanceLog getProcessInstanceLog(long processInstanceId);

	List<ProcessInstanceLog> getProcessInstances(ProcessSorter sorter, Page pager, Date startFrom, Date endBefore,
											   org.flexpay.common.process.persistence.ProcessInstance.STATE state, String name);

	List<ProcessInstanceLog> getProcessInstanceLogsByProcessId(String processId);

	ProcessInstance startProcess(String processId, Map<String, Object> parameters);

	void abortProcessInstance(long processInstanceId);

    void deleteFinishedProcessInstances(DateRange range, String processDefinitionId);

	Map<String, Object> getProcessInstanceVariables(long processInstanceId);

	void setProcessInstanceVariables(long processInstanceId, Map<String, Object> variables);

	void signalExecution(long executionId, String signal);

	void messageExecution(long executionId, String messageName, String messageValue);

	void registerEventListener(ProcessEventListener listener);
}
