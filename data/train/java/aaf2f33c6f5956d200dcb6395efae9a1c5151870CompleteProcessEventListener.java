package com.antmendoza.um.listener;

import org.drools.core.event.DefaultProcessEventListener;
import org.kie.api.event.process.ProcessCompletedEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CompleteProcessEventListener extends DefaultProcessEventListener {
	private Logger log = LoggerFactory
			.getLogger(CompleteProcessEventListener.class);

	@Override
	public void beforeProcessCompleted(ProcessCompletedEvent event) {

		org.kie.api.runtime.process.ProcessInstance processInstance = event
				.getProcessInstance();
		log.info("Completando instancia de proceso con processId=["
				+ processInstance.getProcessId() + "]; id=["+processInstance.getId()+"]");
	}

}
