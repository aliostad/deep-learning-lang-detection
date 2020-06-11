package activiti.test.tools;

import org.activiti.engine.delegate.DelegateExecution;
import org.slf4j.Logger;

public class ServiceTools {

	public static void dumpInstanceState(Logger log, DelegateExecution processInstance) {
		log.info("processInstance.getCurrentActivityName: {}", processInstance.getCurrentActivityName());
		log.info("processInstance.getCurrentActivityId: {}", processInstance.getCurrentActivityId());
		log.info("processInstance.getEventName: {}", processInstance.getEventName());
		log.info("processInstance.getProcessBusinessKey: {}", processInstance.getProcessBusinessKey());
		log.info("processInstance.getProcessDefinitionId: {}", processInstance.getProcessDefinitionId());
		log.info("processInstance.getProcessInstanceId: {}", processInstance.getProcessInstanceId());
		log.info("processInstance.getId: {}", processInstance.getId());

		dumpVariables(log, processInstance);
	}

	public static void dumpVariables(Logger log, DelegateExecution processInstance) {
		for (String variableName : processInstance.getVariableNames()) {
			log.info("Variable: {} = {}", variableName, processInstance.getVariable(variableName));
		}
	}

}
