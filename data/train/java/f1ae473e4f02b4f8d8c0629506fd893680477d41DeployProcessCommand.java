package org.jboss.bam.command;

import org.jbpm.JbpmContext;
import org.jbpm.graph.def.ProcessDefinition;

/**
 * Create a process in the command pattern framework. Upon success the execute
 * method returns the process definition that has been deployed into the
 * database.
 * 
 * @author Fady Matar
 */
public class DeployProcessCommand extends AbstractSeamCommand {

	private static final long serialVersionUID = 1L;

	private ProcessDefinition processDefinition;

	public DeployProcessCommand(ProcessDefinition processDefinition) {
		super();
		this.setProcessDefinition(processDefinition);
	}

	public ProcessDefinition getProcessDefinition() {
		return processDefinition;
	}

	public void setProcessDefinition(ProcessDefinition processDefinition) {
		this.processDefinition = processDefinition;
	}

	public Object execute(JbpmContext jbpmContext) {
		jbpmContext.deployProcessDefinition(this.getProcessDefinition());
		return processDefinition;
	}
}
