package org.jbpm;

import junit.framework.TestCase;

import org.drools.compiler.ProcessBuilderFactory;
import org.drools.marshalling.impl.ProcessMarshallerFactory;
import org.drools.runtime.process.ProcessRuntimeFactory;
import org.jbpm.marshalling.impl.ProcessMarshallerFactoryServiceImpl;
import org.jbpm.process.builder.ProcessBuilderFactoryServiceImpl;
import org.jbpm.process.instance.ProcessRuntimeFactoryServiceImpl;

public abstract class JbpmTestCase extends TestCase {
	
	static {
		ProcessBuilderFactory.setProcessBuilderFactoryService(new ProcessBuilderFactoryServiceImpl());
		ProcessMarshallerFactory.setProcessMarshallerFactoryService(new ProcessMarshallerFactoryServiceImpl());
		ProcessRuntimeFactory.setProcessRuntimeFactoryService(new ProcessRuntimeFactoryServiceImpl());
	}

}
