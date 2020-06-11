package com.sinosoft.one.bpm.service.facade;

import java.math.BigDecimal;
import java.util.List;

import com.sinosoft.one.bpm.model.ProcessInstanceBOInfo;

public interface ProcessInstanceBOService {
	
	void createProcessInstanceBOInfo(ProcessInstanceBOInfo info);
	
	void removeProcessInstanceBOInfo(ProcessInstanceBOInfo info);
	
	void removeProcessInstanceBOInfo(final long piId);
	
	ProcessInstanceBOInfo getProcessInstanceBOInfo(String processId, String businessId);
	
	ProcessInstanceBOInfo getProcessInstanceBOInfo(long processInstanceId);
	
	List<ProcessInstanceBOInfo> getAllNormalProcessInstanceBOInfo();
	
	BigDecimal queryProcessInstanceIdByTaskId(long taskId);
}
