package com.thetdgroup;

/**
 * A package-private utility to add a shutdown hook to kill ongoing encoding
 * processes at the jvm shutdown.
 */
class ProcessKiller extends Thread
{

	/**
	 * The process to kill.
	 */
	private Process process;

	/**
	 * Builds the killer.
	 * 
	 * @param process
	 *         The process to kill.
	 */
	public ProcessKiller(Process process)
	{
	this.process = process;
	}

	/**
	 * It kills the supplied process.
	 */
	public void run()
	{
	process.destroy();
	}

}
