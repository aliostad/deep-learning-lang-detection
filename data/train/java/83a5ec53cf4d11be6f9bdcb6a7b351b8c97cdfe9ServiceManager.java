package com.forum.service;

public class ServiceManager {

	private UserService userService;
	private TopicService topicService;
	private ReviewService reviceService;
	public UserService getUserService() {
		return userService;
	}
	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	public TopicService getTopicService() {
		return topicService;
	}
	public void setTopicService(TopicService topicService) {
		this.topicService = topicService;
	}
	public ReviewService getReviceService() {
		return reviceService;
	}
	public void setReviceService(ReviewService reviceService) {
		this.reviceService = reviceService;
	}
}
