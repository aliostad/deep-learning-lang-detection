package org.cmdbuild.workflow;

import org.enhydra.shark.api.client.wfmc.wapi.WMSessionHandle;

public interface SimpleEventManager {

	interface ProcessInstance {
		WMSessionHandle getSessionHandle();

		String getProcessDefinitionId();

		String getProcessInstanceId();
	}

	interface ActivityInstance extends ProcessInstance {
		String getActivityDefinitionId();

		String getActivityInstanceId();

		boolean isNoImplementationActivity();
	}

	void processStarted(ProcessInstance processInstance);

	void processClosed(ProcessInstance processInstance);

	void processSuspended(ProcessInstance processInstance);

	void processResumed(ProcessInstance processInstance);

	void activityStarted(ActivityInstance activityInstance);

	void activityClosed(ActivityInstance activityInstance);

}
