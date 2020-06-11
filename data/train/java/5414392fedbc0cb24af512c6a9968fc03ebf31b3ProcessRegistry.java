package org.tc.perf.process;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.log4j.Logger;

/**
 * Keeps a registry of the processes running on an Agent. Helps in killing
 * processes on error state or aborting the test.
 *
 * @author Himadri Singh
 */
public class ProcessRegistry {

	private static Map<String, ProcessThread> map = new ConcurrentHashMap<String, ProcessThread>();
	private static Logger log = Logger.getLogger(ProcessRegistry.class);

	private ProcessRegistry() {
	}

	private static class ProcessRegistryHolder {
		private static ProcessRegistry instance = new ProcessRegistry();
	}

	/**
	 * @return singleton instance
	 */
	public static ProcessRegistry getInstance() {
		return ProcessRegistryHolder.instance;
	}

	/**
	 * Register the process with the process name provided
	 *
	 * @param processName
	 * @param process
	 */
	void register(String processName, ProcessThread process) {
		map.put(processName, process);
	}

	/**
	 * Remove the process with the process name provided. Process is not killed
	 * for this call.
	 *
	 * @param processName
	 */
	void unregister(String processName) {
		if (processName != null)
			map.remove(processName);
	}

	/**
	 * Kill the process and remove from registry
	 *
	 * @param processName
	 * @return true when process killed successfully
	 */
	public boolean killProcess(String processName) {
		if (processName != null) {
			ProcessThread pt = map.remove(processName);
			if (pt != null)
				pt.destroy();
			else {
				log.warn("Process thread not found for " + processName
						+ ". Not killing any process.");
				return Boolean.FALSE;
			}
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}

	/**
	 * Kill and remove all the processes running on the agent
	 */
	public void killAllProcesses() {
		log.info(String.format("Killing %d process(es) on this agent.",
				map.size()));
		for (ProcessThread p : map.values())
			p.destroy();
	}

	/**
	 * Process is already registered
	 *
	 * @param processName
	 * @return true, if process is already present in the registry
	 */
	boolean isRegistered(String processName) {
		if (map.get(processName) == null)
			return Boolean.FALSE;
		return Boolean.TRUE;
	}

}
