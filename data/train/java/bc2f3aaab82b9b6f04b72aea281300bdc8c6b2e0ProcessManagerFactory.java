/**
 * Copyright (c) 2009 Aurora Software Technology Studio. All rights reserved.
 */
package com.corona.bpm;

import com.corona.bpm.spi.ProcessManagerImpl;

/**
 * <p> </p>
 *
 * @author $Author$
 * @version $Id$
 */
public final class ProcessManagerFactory {

	/**
	 * the process manager
	 */
	private static ProcessManager processManager;
	
	/**
	 * utility class
	 */
	private ProcessManagerFactory() {
		// do nothing
	}
	
	/**
	 * @return the process manager
	 */
	public static ProcessManager getInstance() {
		
		if (processManager == null) {
			processManager = new ProcessManagerImpl();
		}
		return processManager;
	}
}
