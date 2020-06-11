package com.eamtar.mccn.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eamtar.mccn.email.EmailService;

@Service
public class ManagerService {
	@Autowired
	private UserService userService;
	@Autowired
	private UserProfileService userProfileService;
	@Autowired
	private MessageService messageService;
	@Autowired
	private EmailService emailService;
	@Autowired
	private VideoService videoService;
	
	public UserService getUserService() {
		return userService;
	}
	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public UserProfileService getUserProfileService() {
		return userProfileService;
	}
	public void setUserProfileService(UserProfileService userProfileService) {
		this.userProfileService = userProfileService;
	}
	public MessageService getMessageService() {
		return messageService;
	}
	public void setMessageService(MessageService messageService) {
		this.messageService = messageService;
	}
	public EmailService getEmailService() {
		return emailService;
	}
	public void setEmailService(EmailService emailService) {
		this.emailService = emailService;
	}
	public VideoService getVideoService() {
		return videoService;
	}
	public void setVideoService(VideoService videoService) {
		this.videoService = videoService;
	}	
}