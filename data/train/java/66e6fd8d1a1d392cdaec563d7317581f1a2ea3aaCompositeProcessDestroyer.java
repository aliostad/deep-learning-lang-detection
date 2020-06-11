package uk.co.datumedge.redislauncher;

import org.apache.commons.exec.ProcessDestroyer;

final class CompositeProcessDestroyer implements ProcessDestroyer {
	private final ProcessDestroyer[] processDestroyers;

	public CompositeProcessDestroyer(ProcessDestroyer processDestroyer,
			ProcessDestroyer... processDestroyers) {
		this.processDestroyers = new ProcessDestroyer[processDestroyers.length + 1];
		this.processDestroyers[0] = processDestroyer;
		System.arraycopy(processDestroyers, 0, this.processDestroyers, 1, processDestroyers.length);
	}

	@Override
	public boolean add(Process process) {
		for (ProcessDestroyer processDestroyer : processDestroyers) {
			processDestroyer.add(process);
		}
		return true;
	}

	@Override
	public boolean remove(Process process) {
		for (ProcessDestroyer processDestroyer : processDestroyers) {
			processDestroyer.remove(process);
		}
		return true;
	}

	@Override
	public int size() {
		return -1;
	}
}
