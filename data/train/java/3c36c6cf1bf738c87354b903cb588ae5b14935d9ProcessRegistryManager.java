/**
 * 
 */
package com.openappengine.bpm.procrepo;

import java.io.InputStream;

import com.openappengine.bpm.graph.ProcessDefinition;
import com.openappengine.bpm.procreader.ProcessDefReader;
import com.openappengine.utility.UtilString;

/**
 * @author hrishi
 * 
 */
public class ProcessRegistryManager implements IProcessRegistryManager {

	public ProcessRegistryManager() {
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.openappengine.bpm.procrepo.IProcessRegistryManager#loadProcessRegistry
	 * (java.io.File[])
	 */
	public void loadProcessRegistry(String[] definitionFiles)
			throws ProcessRegistryException {
		if (definitionFiles != null && definitionFiles.length != 0) {
			for (String file : definitionFiles) {
				loadProcessRegistry(file);
			}
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.openappengine.bpm.procrepo.IProcessRegistryManager#loadProcessRegistry
	 * (java.io.File)
	 */
	public void loadProcessRegistry(String file)
			throws ProcessRegistryException {
		try {
			InputStream inputStream = getClass().getClassLoader()
					.getResourceAsStream(file);
			ProcessDefReader defReader = new ProcessDefReader(inputStream);
			ProcessDefinition processDefinition = defReader
					.readProcessDefinition();
			ProcessRegistry.registerProcessInstance(processDefinition);
		} catch (Exception e) {
			throw new ProcessRegistryException(e);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openappengine.bpm.procrepo.IProcessRegistryManager#
	 * getProcessInstanceByProcessId(java.lang.String)
	 */
	public ProcessDefinition getProcessInstanceByProcessId(String processId)
			throws ProcessRegistryException {
		if (UtilString.isEmptyOrBlank(processId)) {
			throw new ProcessRegistryException("ProcessId cannot be empty.");
		}
		ProcessDefinition processDefinition = ProcessRegistry
				.getProcessInstanceByProcessId(processId);
		return processDefinition;
	}

}
