package com.dobarizbor.service.process;

import com.dobarizbor.domain.process.ProcessState;
import com.dobarizbor.service.process.job.Job;
import com.dobarizbor.service.process.job.JobState;

import java.util.List;

import com.dobarizbor.domain.util.profile.Option;

public interface ProcessManager {
	void stopProcess(String p_jobId);
	
	void startProcess(String p_jobId, List<Option> p_options);
	
	String startProcess(Job p_job, List<Option> p_options);
	
	JobState getJobState(String p_processId);
	
	Job getJob(String p_processId);
	
	ProcessState getProcessState(String p_processId);
	
	List<ProcessState> getProcessesStates();
	
	void enableProcess(String p_processId, boolean p_enabled);
	 
}
