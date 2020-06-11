package uk.co.datumedge.redislauncher;

import java.util.Collection;
import java.util.HashSet;

import org.apache.commons.exec.ProcessDestroyer;

final class ExecutionProcessDestroyer implements ProcessDestroyer {
	private final Collection<Process> processes = new HashSet<Process>();

	@Override
	public boolean add(Process process) {
		return processes.add(process);
	}

	@Override
	public boolean remove(Process process) {
		return processes.remove(process);
	}

	@Override
	public int size() {
		return processes.size();
	}

	public void destroy() {
		for (Process process : processes) {
			process.destroy();
		}
	}
}
