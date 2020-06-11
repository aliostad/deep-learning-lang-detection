package com.antmendoza.um.listener;

import org.drools.core.event.DefaultProcessEventListener;
import org.kie.api.event.process.ProcessStartedEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StartProcessEventListener extends DefaultProcessEventListener {
	private Logger log = LoggerFactory
			.getLogger(StartProcessEventListener.class);

	@Override
	public void beforeProcessStarted(ProcessStartedEvent event) {

		org.kie.api.runtime.process.ProcessInstance processInstance = event
				.getProcessInstance();
		log.info("Nueva instancia de proceso con processId=["
				+ processInstance.getProcessId() + "]; id=["
				+ processInstance.getId() + "]");

		event.getKieRuntime().insert(processInstance);
	}

}
