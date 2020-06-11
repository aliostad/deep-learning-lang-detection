package by.easyandroid.service.compilation;

import by.easyandroid.service.amazon.CloudQueueService;

public class BuildTaskService {

	private CloudQueueService queueService;
	
	public BuildTaskService(CloudQueueService queueService) {
		this.queueService = queueService;
	}

	public void sendBuildTask(String applicationId) {
		queueService.sendMessage(applicationId);
	}

	public CloudQueueService getQueueService() {
		return queueService;
	}

	public void setQueueService(CloudQueueService queueService) {
		this.queueService = queueService;
	}
}