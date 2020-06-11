package org.wf.dao.activiti;

import org.wf.service.model.WorkflowProcess;

/**
 * dao interface
 * @author zhurunjia
 *
 */
public interface WorkflowProcessDao {
	
	/**
	 * save the newly incoming process
	 * @param procese
	 */
	void saveProcess(WorkflowProcess process);
	
	/**
	 * query the specified workflow process
	 * @param innerProcessId
	 * @return
	 */
	WorkflowProcess queryByProcessId(String innerProcessId);
	
	/**
	 * update
	 * @param process
	 */
	void updateProcess(WorkflowProcess process);

}
