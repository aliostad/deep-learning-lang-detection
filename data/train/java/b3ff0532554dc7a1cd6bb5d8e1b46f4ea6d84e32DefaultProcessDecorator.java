package ch.fhnw.mdt.forthdebugger.communication.process;

import java.io.InputStream;
import java.io.OutputStream;

/**
 * Default implementation which just forwards to a {@link Process}.
 *
 */
public class DefaultProcessDecorator implements IProcessDectorator {

	private final Process process;

	public DefaultProcessDecorator(Process process) {
		this.process = process;
	}

	@Override
	public void destroy() {
		process.destroyForcibly();
	}

	@Override
	public InputStream getInputStream() {
		return process.getInputStream();
	}

	@Override
	public OutputStream getOutputStream() {
		return process.getOutputStream();
	}

}
