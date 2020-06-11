package process.face;

import java.util.HashMap;
import java.util.Map;

import process.base.Process;

public class ProcessManager {
	public static Map<Integer, Process> processPool = new HashMap<Integer, Process>();

	public static void starProcess(Process process) {
		Thread thread = null;
		if (process.startMode == Process.START_MODE_SINGLE) {
			if (processPool.get(process.processId) == null) {
				processPool.put(process.processId, process);
			}
			thread = new Thread(processPool.get(process.processId));
		} else if (process.startMode == Process.START_MODE_MULTI) {
			thread = new Thread(process);
		}
		thread.start();
	}
}
