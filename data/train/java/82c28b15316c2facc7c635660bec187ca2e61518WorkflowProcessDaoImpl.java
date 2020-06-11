package org.wf.dao.activiti.impl;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;
import org.wf.dao.activiti.WorkflowProcessDao;
import org.wf.service.model.WorkflowProcess;

@Repository("workflowProcessDao")
public class WorkflowProcessDaoImpl extends BaseDaoSupport implements WorkflowProcessDao {
	
	@Override
	public void saveProcess(WorkflowProcess process) {
		if (process.validate()) {
			getSqlMapClientTemplate().insert("wf_process.insert", process);
		}
	}

	@Override
	public WorkflowProcess queryByProcessId(String innerProcessId) {
		
		List<WorkflowProcess> processList = getSqlMapClientTemplate().queryForList("wf_process.queryByProcessId", innerProcessId);
		
		if ( processList != null && processList.size() > 0) {
			return processList.get(0);
		}
		return null;
	}

	@Override
	public void updateProcess(WorkflowProcess process) {
		if(process.validate() && StringUtils.isNotEmpty(process.getInnerProcessId()) ) {
			getSqlMapClientTemplate().update("wf_process.update", process);
		}
	}

}
