package com.dobarizbor.facade.util;

import com.dobarizbor.domain.process.ProcessState;
import com.dobarizbor.granite.GraniteDynamicDestination;
import com.dobarizbor.service.process.ProcessManager;

import java.util.List;

import com.dobarizbor.domain.util.profile.Option;

public class ProcessManagerFacadeImpl implements ProcessManagerFacade, GraniteDynamicDestination {
	private ProcessManager m_processManager;
	
	public ProcessManagerFacadeImpl(
			ProcessManager p_processManager) {
		super();
		m_processManager = p_processManager;
	}
	
	public ProcessState getProcessState(String p_processId) {
		return m_processManager.getProcessState(p_processId);
	}
	public List<ProcessState> getProcessesStates() {
		return m_processManager.getProcessesStates();
	}
	public List<String> listAllProcessIds() {
		return null;
	}
	public void startProcessing(String p_processId, List<Option> p_options) {
		m_processManager.startProcess(p_processId, p_options);
	}
	public void stopProcessing(String p_processId) {
		m_processManager.stopProcess(p_processId);
	}

	public void enableProcessing(String p_processId, boolean p_enabled) {
		m_processManager.enableProcess(p_processId, p_enabled);
		
	}
}
