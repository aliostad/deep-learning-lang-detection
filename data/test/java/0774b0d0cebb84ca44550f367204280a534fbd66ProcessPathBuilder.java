package org.mahu.proto.restapp.model.impl;
import static org.mahu.proto.restapp.model.impl.ModelAssert.checkNotNull;

import org.mahu.proto.restapp.model.ProcessPath;
public class ProcessPathBuilder extends ProcessBuilder {
	
	ProcessPathBuilder(final String aName, final ProcessBuilder processBuilder) throws ProcessBuilderException {
		super(aName, processBuilder);
		checkNotNull(processBuilder,"Parent not defined");
	}
	
	public ProcessPath getProcessPath() throws ProcessBuilderException {
		return (ProcessPath)processDef;
	}
	
	protected ProcessDefinitionImpl createNewProcessDefinition(final String name) throws ProcessBuilderException {
		return new ProcessPathImpl(parent.processDef, name);
	}
	
}
