package uk.co.datumedge.redislauncher;

import org.apache.commons.exec.ProcessDestroyer;

/**
 * A {@code ProcessDestroyer} implementation that does nothing.
 */
public final class NullProcessDestroyer implements ProcessDestroyer {
	/**
	 * A singleton instance of the {@code NullProcessDestroyer}.
	 */
	public static final ProcessDestroyer INSTANCE = new NullProcessDestroyer();

	private NullProcessDestroyer() {
	}

	@Override
	public boolean add(Process process) {
		return false;
	}

	@Override
	public boolean remove(Process process) {
		return false;
	}

	@Override
	public int size() {
		return -1;
	}
}
