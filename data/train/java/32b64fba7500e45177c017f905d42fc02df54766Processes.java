package jProcess;

import jProcess.unix.UnixProcessDetails;
import jProcess.unix.UnixProcessDetailsFactory;
import jProcess.util.OS;

import java.util.List;

public class Processes {
	
	static OS LOCAL_OS;
	static ProcessDetailsFactory<? extends ProcessDetails> PROCESS_FACTORY;
	
	static void init() {
		if (LOCAL_OS == null) {
			LOCAL_OS = OS.detect();
			
			switch (LOCAL_OS) {
			case UNIX:
			case LINUX:
			case MAC:
			case SOLARIS:
				PROCESS_FACTORY = new UnixProcessDetailsFactory<UnixProcessDetails>();
				break;
			case WINDOWS:
				break;
			}
			
			PROCESS_FACTORY.checkSupported();
		}
	}
	
	public static List<ProcessDetails> listAll() {
		return listAll(false);
	}
	
	@SuppressWarnings("unchecked")
	public static List<ProcessDetails> listAll(boolean updateAll) {
		init();
		return (List<ProcessDetails>) PROCESS_FACTORY.listProcesses(updateAll);
	}

	public static ProcessDetails getProcess(int pid) {
		init();
		return PROCESS_FACTORY.getProcess(pid);
	}
	
	public static void updateStats(ProcessDetails process) {
		init();
		PROCESS_FACTORY.updateStats(process);
	}
	
	public static void stopProcess(ProcessDetails process) {
		init();
		PROCESS_FACTORY.stopProcess(process);
	}
	
	public static void killProcess(ProcessDetails process) {
		init();
		PROCESS_FACTORY.killProcess(process);
	}
}
