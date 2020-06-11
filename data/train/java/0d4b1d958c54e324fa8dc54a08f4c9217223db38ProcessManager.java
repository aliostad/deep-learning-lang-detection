package org.flexpay.common.process;

import org.flexpay.common.dao.paging.Page;
import org.flexpay.common.persistence.DateRange;
import org.flexpay.common.process.exception.ProcessDefinitionException;
import org.flexpay.common.process.exception.ProcessInstanceException;
import org.flexpay.common.process.filter.ProcessNameFilter;
import org.flexpay.common.process.persistence.ProcessInstance;
import org.flexpay.common.process.sorter.ProcessSorter;
import org.flexpay.common.service.Roles;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.springframework.security.access.annotation.Secured;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

public interface ProcessManager {

	/**
	 * Key name used to store security context
	 */
	public static final String PARAM_SECURITY_CONTEXT = "PROCESS_MANAGER_SECURITY_CONTEXT";

	@Secured (Roles.PROCESS_DELETE)
	void deleteProcessInstance(@NotNull ProcessInstance process);

	@Secured (Roles.PROCESS_DELETE)
	void deleteProcessInstances(List<ProcessInstance> processes);

	@Secured (Roles.PROCESS_DELETE)
	void deleteProcessInstances(Set<Long> processIds);

	/**
	 * Wait for process completion
	 *
	 * @param processId ProcessInstance id
	 * @throws InterruptedException if waiting thread is interrupted
	 */
	void join(long processId) throws InterruptedException;

	/**
	 * Create process for process definition name by last version
	 *
	 * @param definitionId process definition id
	 * @param parameters	 initial context variables
	 * @return process instance identifier
	 * @throws org.flexpay.common.process.exception.ProcessInstanceException
	 *                                    when can't instantiate process instance
	 * @throws ProcessDefinitionException when process definition not found
	 */
	@Secured (Roles.PROCESS_START)
	ProcessInstance startProcess(@NotNull String definitionId, @Nullable Map<String, Object> parameters)
			throws ProcessInstanceException, ProcessDefinitionException;

	/**
	 * Create process for process definition name by version
	 *
	 * @param definitionId process definition id
	 * @param parameters	 initial context variables
	 * @param  processDefinitionVersion process definition version
	 * @return process instance identifier
	 * @throws org.flexpay.common.process.exception.ProcessInstanceException
	 *                                    when can't instantiate process instance
	 * @throws ProcessDefinitionException when process definition not found
	 */
	@Secured (Roles.PROCESS_START)
	ProcessInstance startProcess(@NotNull String definitionId, @Nullable Map<String, Object> parameters, @Nullable Long processDefinitionVersion)
			throws ProcessInstanceException, ProcessDefinitionException;

	@Secured (Roles.PROCESS_END)
    void endProcess(@NotNull ProcessInstance process);

	/**
	 * Get list of system processes
	 *
	 * @return Process list
	 */
	@Secured (Roles.PROCESS_READ)
	List<ProcessInstance> getProcesses();

	/**
	 * Get paged list of system processes
	 *
	 * @param pager pager
	 * @return Process list
	 */
	@Secured (Roles.PROCESS_READ)
	List<ProcessInstance> getProcesses(Page<ProcessInstance> pager);

	/**
	 * Get paged list of system processes filtered by state, "start from" and "end before" dates
	 *
	 * @param processSorter process sorter
	 * @param pager pager
	 * @param startFrom lower bound for process start date (if null will not be used)
	 * @param endBefore upper bound for process end date (if null will not be used)
	 * @param state state allowed by filter (if null will not be used)
	 * @param name name allowed by filter (if null will not be used)
	 * @return Process list
	 */
	@Secured (Roles.PROCESS_READ)
	List<ProcessInstance> getProcesses(ProcessSorter processSorter, Page<ProcessInstance> pager, Date startFrom, Date endBefore, ProcessInstance.STATE state, String name);

	/**
	 * Retrieve process instance
	 *
	 * @param processId ProcessInstance id
	 * @return Process info
	 */
	@Secured (Roles.PROCESS_READ)
	@Nullable
	ProcessInstance getProcessInstance(@NotNull Long processId);

	@Secured (Roles.PROCESS_READ)
	@NotNull
	List<ProcessInstance> getProcessInstances();

	@Secured (Roles.PROCESS_DELETE)
	void deleteProcessInstances(DateRange range, String processDefinitionName);

	@Secured (Roles.PROCESS_READ)
	List<ProcessInstance> getProcessInstances(@NotNull String definitionId);

	void signalExecution(@NotNull ProcessInstance execution, String signal);

	void messageExecution(@NotNull ProcessInstance execution, @NotNull String messageName, @NotNull String messageValue);

	boolean isHumanTaskExecute(@NotNull ProcessInstance processInstance);

	@Secured (Roles.PROCESS_COMPLETE_HUMAN_TASK)
	boolean completeHumanTask(@NotNull ProcessInstance processInstance, @NotNull String actorId, @Nullable String result);
}
