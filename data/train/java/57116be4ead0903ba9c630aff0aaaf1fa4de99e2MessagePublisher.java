package com.service.redis;

import com.service.async.Callback;

public class MessagePublisher implements Callback {

	private ObjectRepository objectRepository;
	private String key;
	
	public ObjectRepository getObjectRepository() {
		return objectRepository;
	}
	public void setObjectRepository(ObjectRepository objectRepository) {
		this.objectRepository = objectRepository;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	@Override
	public void execute(String response) {
		objectRepository.add(key, response);
	}
	
	
}
