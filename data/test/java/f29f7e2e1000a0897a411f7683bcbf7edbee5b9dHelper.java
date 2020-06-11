package com.xysd.internal_wf.operation;

import com.xysd.internal_wf.domain.ProcessConfig;
import com.xysd.internal_wf.domain.ProcessDefinition;
import com.xysd.internal_wf.domain.parser.XmlParser;

public class Helper {
	
	public static final ProcessConfig findProcessConfig(String processName,ProcessDeployer processDeployer){
		ProcessDefinition lastedProcessDefinition =processDeployer.getLastProcessDefinition(processName);
		XmlParser parser = new XmlParser(lastedProcessDefinition.getContent());
		ProcessConfig config = parser.parse();
		config.setProcessDefinitionId(lastedProcessDefinition.getId());
		return config;
		
		
	}

}
