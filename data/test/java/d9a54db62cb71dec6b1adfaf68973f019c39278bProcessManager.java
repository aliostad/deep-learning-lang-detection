package controler;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.lang.RandomStringUtils;

public class ProcessManager {

	private static Map<Integer, String> processOutput = new ConcurrentHashMap<Integer, String>();

	private static Map<Integer, Process> processObject = new ConcurrentHashMap<Integer, Process>();

	private static Map<Integer, String> processKey = new ConcurrentHashMap<Integer, String>();

	public static Process getProcessObject(int index) {
		return processObject.get(index);
	}

	public static void addProcess(int index, Process process, String key) {
		processObject.put(index, process);
		processKey.put(index, key);
		processOutput.put(index, "");
	}

	public static String getProcessOutput(int i) {
		if (processOutput.containsKey(i)) {
			return processOutput.get(i);
		} else {
			return "";
		}
	}

	public static void setProcessOutput(int i, String output) {
		processOutput.put(i, output);
	}

	public static void killProcess(int index,String key) {

		if (processKey.get(index).equals(key)){
			
			Process p = processObject.get(index);
			p.destroy();
			System.out.println("Process was killed.");
			
		}
	}

}
