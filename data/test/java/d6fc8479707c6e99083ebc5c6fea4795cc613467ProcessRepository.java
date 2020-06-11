package org.uncertweb.ps.process;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.uncertweb.ps.Config;

public class ProcessRepository {

	private static Map<String, AbstractProcess> processes;
	private static ProcessRepository instance;
	private static final Logger logger = Logger.getLogger(ProcessRepository.class);
	
	private ProcessRepository() {
		processes = new LinkedHashMap<String, AbstractProcess>();
		List<String> processClasses = Config.getInstance().getProcessClasses();
		for (String c : processClasses) {
			try {
				addProcess((AbstractProcess) Class.forName(c).newInstance());
				logger.info("Loaded process class " + c + ".");
			}
			catch (ClassNotFoundException e) {
				logger.error("Couldn't find process class " + c + ", skipping.");
			}
			catch (InstantiationException e) {
				logger.error("Couldn't instantiate process class " + c + ", skipping.");
			}
			catch (IllegalAccessException e) {
				logger.error("Couldn't access process class " + c + ", skipping.");
			}
			catch (ClassCastException e) {
				logger.error("Process class " + c + " does not extend org.uncertweb.ps.process.AbstractProcess, skipping.");
			}
		}
	}
	public static ProcessRepository getInstance() {
		if (instance == null) {
			instance = new ProcessRepository();
		}
		return instance;
	}
	
	public void addProcess(AbstractProcess process) {
		String name = process.getIdentifier();
		processes.put(name, process);
	}
	
	public AbstractProcess getProcess(String processIdentifier) {
		return processes.get(processIdentifier);
	}
	
	public List<AbstractProcess> getProcesses() {
		List<AbstractProcess> processList = new ArrayList<AbstractProcess>();
		processList.addAll(processes.values());
		return processList;
	}
	
}
