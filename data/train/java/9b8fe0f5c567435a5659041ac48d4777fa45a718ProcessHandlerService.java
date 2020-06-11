package com.zend.zendserver.bamboo.Process;

import com.atlassian.bamboo.build.logger.BuildLogger;
import com.zend.zendserver.bamboo.Env.BuildEnv;

public class ProcessHandlerService {
	
	private BuildEnv buildEnv;
	private BuildLogger buildLogger;
	private ProcessService processService;
	
	public BuildEnv getBuildEnv() {
		return buildEnv;
	}

	public void setBuildEnv(BuildEnv buildEnv) {
		this.buildEnv = buildEnv;
	}

	public BuildLogger getBuildLogger() {
		return buildLogger;
	}

	public void setBuildLogger(BuildLogger buildLogger) {
		this.buildLogger = buildLogger;
	}
	
	public ProcessHandler applicationGetDetails(String applicationId) {
		ApplicationGetDetailsProcess applicationGetDetailsProcess = processService.applicationGetDetails();
		applicationGetDetailsProcess.incTestIteration();
		applicationGetDetailsProcess.setApplicationId(applicationId);
		
		ProcessHandler applicationGetDetailsProcessHandler = new ProcessHandler(applicationGetDetailsProcess, buildLogger);
		applicationGetDetailsProcessHandler.setBuildEnv(buildEnv);
		
		return applicationGetDetailsProcessHandler;
	}
	
	public Process deploymentProcess() {
		Process deploymentProcess = processService.deployment();
		return deploymentProcess;
	}
	
	public ProcessHandler deployment() {
		Process deploymentProcess = processService.deployment();
		
		ProcessHandler deployProcessHandler = new ProcessHandler(deploymentProcess, buildLogger);
		deployProcessHandler.setBuildEnv(buildEnv);
		
		return deployProcessHandler;
	}
	
	public ProcessHandler packaging() {
		PackagingProcess packagingProcess = processService.packaging();
		ProcessHandler processHandler = new ProcessHandler(packagingProcess, buildLogger);
		processHandler.setBuildEnv(buildEnv);
		
		return processHandler;
	}

	public ProcessService getProcessService() {
		return processService;
	}

	public void setProcessService(ProcessService processService) {
		this.processService = processService;
	}

	public ProcessHandler applicationGetStatus() {
		ApplicationGetStatusProcess applicationGetStatusProcess = processService.applicationGetStatus();
		applicationGetStatusProcess.incTestIteration();
		
		ProcessHandler applicationGetStatusProcessHandler = new ProcessHandler(applicationGetStatusProcess, buildLogger);
		applicationGetStatusProcessHandler.setBuildEnv(buildEnv);
		
		return applicationGetStatusProcessHandler;
	}

	public ProcessHandler rollback(String applicationId) {
		RollbackProcess rollbackProcess = processService.rollback();
		rollbackProcess.setApplicationId(applicationId);
		
		ProcessHandler rollbackProcessHandler = new ProcessHandler(rollbackProcess, buildLogger);
		rollbackProcessHandler.setBuildEnv(buildEnv);
		
		return rollbackProcessHandler;
	}
	
	public ProcessHandler monitorGetIssuesListPredefinedFilter(long from, long to, boolean periodBeforeDeployment) {
		MonitorGetIssuesListPredefinedFilterProcess process = processService.monitorGetIssuesListPredefinedFilterProcess();
		process.setFilterId("All Issues");
		process.setFrom(Long.toString(from));
		process.setTo(Long.toString(to));
		process.setPeriodBeforeDeployment(periodBeforeDeployment);
		
		ProcessHandler issuesListProcessHandler = new ProcessHandler(process, buildLogger);
		issuesListProcessHandler.setBuildEnv(buildEnv);
		
		return issuesListProcessHandler;
	}
}
