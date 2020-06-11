#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.webapp.action.process;

import java.util.List;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.repository.ProcessDefinition;

import ${package}.process.ProcessConstants;

/**
 * 已结束的流程实例料别
 * @author yyang
 *
 */
public class FinishedProcessesAction extends BaseProcessAction {
	
	private static final long serialVersionUID = 2644668803370797254L;

	public List<HistoricProcessInstance> getProcessInstances() {
		return historyService.createHistoricProcessInstanceQuery().finished().list();
	}
	
	public String getInitiator(HistoricProcessInstance processInstance) {
		return (String) getProcessVariable(processInstance, ProcessConstants.INITIATOR);
	}
	
	public String getTitle(HistoricProcessInstance processInstance) {
		return (String) getProcessVariable(processInstance, ProcessConstants.TITLE);
	}
	
	public boolean isPassed(HistoricProcessInstance processInstance) {
		return (Boolean) getProcessVariable(processInstance, ProcessConstants.PASSED);
	}

	public String getProcessKey(HistoricProcessInstance processInstance) {
		String processDefinitionId = processInstance.getProcessDefinitionId();
		return repositoryService.createProcessDefinitionQuery().processDefinitionId(processDefinitionId).singleResult().getKey();
	}

	public String getProcessName(HistoricProcessInstance processInstance) {
		String processDefinitionId = processInstance.getProcessDefinitionId();
		return repositoryService.createProcessDefinitionQuery().processDefinitionId(processDefinitionId).singleResult().getName();
	}
	
	public ProcessDefinition getProcessDefinition(HistoricProcessInstance processInstance) {
		String processDefinitionId = processInstance.getProcessDefinitionId();
		return repositoryService.createProcessDefinitionQuery().processDefinitionId(processDefinitionId).singleResult();
	}
	
	private Object getProcessVariable(HistoricProcessInstance processInstance, String variableName) {
		return historyService.createHistoricVariableInstanceQuery()
				.processInstanceId(processInstance.getId())
				.variableName(variableName)
				.singleResult()
				.getValue();
	}
}
