/**
 *
 */
package com.teefun.util;

/**
 * Utility class for java process.
 *
 * @author Rajh
 *
 */
public final class ProcessUtil {

	/**
	 * Private constructor for utility classes.
	 */
	private ProcessUtil() {

	}

	/**
	 * Is the process running.
	 *
	 * @param process the process
	 * @return true if the process is running
	 */
	public static boolean isRunning(final Process process) {
		try {
			process.exitValue();
			return false;
		} catch (final Exception e) {
			return true;
		}
	}

}
