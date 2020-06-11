package com.saiteng.smartlisten.process;

import java.util.ArrayList;
import java.util.List;

import com.smarteye.bean.JNIMessage;

public class ProcessManager {
	private List<Process> processes = new ArrayList<Process>();

	public void addProcess(Process process) {
		processes.add(process);
	}

	public boolean process(JNIMessage message) {
		for (Process process : processes) {
			boolean result = process.process(message);
			if (result)
				return true;
		}
		return false;
	}

	public void removeProcess(Process process) {
		processes.remove(process);
	}

}
