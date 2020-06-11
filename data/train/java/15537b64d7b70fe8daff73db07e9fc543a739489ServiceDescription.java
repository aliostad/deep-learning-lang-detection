package org.uncertweb.et.description;

import java.util.ArrayList;
import java.util.List;

public class ServiceDescription {

	private List<ProcessDescription> processDescriptions;
	
	public ServiceDescription() {
		processDescriptions = new ArrayList<ProcessDescription>();
	}
	
	public void addProcessDescription(ProcessDescription processDescription) {
		processDescriptions.add(processDescription);
	}
	
	public List<String> getProcessIdentifiers() {
		List<String> processNames = new ArrayList<String>();
		for (ProcessDescription processDescription : processDescriptions) {
			processNames.add(processDescription.getIdentifier());
		}
		return processNames;
	}
	
	public List<ProcessDescription> getProcessDescriptions() {
		return processDescriptions;
	}
	
	public ProcessDescription getProcessDescription(String processName) {
		for (ProcessDescription processDescription : processDescriptions) {
			if (processDescription.getIdentifier().equals(processName)) {
				return processDescription;
			}
		}
		return null;
	}
	
}
