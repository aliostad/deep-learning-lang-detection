/**
 * Copyright (c) 2009 Aurora Software Technology Studio. All rights reserved.
 */
package com.corona.bpm;

import java.io.InputStream;
import java.util.List;

/**
 * <p> </p>
 *
 * @author $Author$
 * @version $Id$
 */
public interface ProcessManager {

	/**
	 * @param stream the input stream
	 * @throws ProcessException if fail to install definition file
	 */
	void install(InputStream stream) throws ProcessException;

	/**
	 * @param resource the resource file of definition
	 * @throws ProcessException if fail to install definition file
	 */
	void install(String resource) throws ProcessException;
	
	/**
	 * @param name the process name
	 * @return the new process
	 */
	Process createProcess(final String name);
	
	/**
	 * @param id the process id
	 * @return the active process or <code>null</code> if does not exist
	 * @exception ProcessException if fail to load process
	 */
	Process getActiveProcess(Long id) throws ProcessException;

	/**
	 * @param name the process name
	 * @return all active processes
	 * @exception ProcessException if fail to load processes
	 */
	List<Process> getActiveProcesses(final String name) throws ProcessException;

	/**
	 * @return all active processes
	 * @exception ProcessException if fail to load processes
	 */
	List<Process> getActiveProcesses() throws ProcessException;

	/**
	 * @param id the process id
	 * @return the process or <code>null</code> if does not exist
	 * @exception ProcessException if fail to load process
	 */
	Process getProcess(Long id) throws ProcessException;
	
	/**
	 * @param name the process name
	 * @return all processes
	 * @exception ProcessException if fail to load processes
	 */
	List<Process> getProcesses(final String name) throws ProcessException;
	
	/**
	 * @return all processes
	 * @exception ProcessException if fail to load processes
	 */
	List<Process> getProcesses() throws ProcessException;
}
