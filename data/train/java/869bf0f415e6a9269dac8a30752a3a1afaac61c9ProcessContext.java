package com.chinesedreamer.fastdev.workflow;


public class ProcessContext {
	protected static final ThreadLocal<ProcessContext> CURRENT = new ThreadLocal<ProcessContext>();
	private static Process process;
	private static ProcessManager processManager;

	public static ThreadLocal<ProcessContext> getCurrent() {
		return CURRENT;
	}
	
	public static void setCurrent(ProcessContext context) {
		CURRENT.set(context);
	}

	public static Process getProcess() {
		return process;
	}

	public static void setProcess(Process process) {
		ProcessContext.process = process;
	}

	public static ProcessManager getProcessManager() {
		return processManager;
	}

	public static void setProcessManager(ProcessManager processManager) {
		ProcessContext.processManager = processManager;
	}
	
	public static void setContext(ProcessContext context,Process process,ProcessManager processManager) {
		CURRENT.set(context);
		setProcess(process);
		setProcessManager(processManager);
	}
}
