package com.lea.service;

import java.util.List;

import com.lea.model.Mail;
import com.lea.repository.MailRepository;

public class MailServiceImpl implements MailService {

	private MailRepository repository;

	public void sendMail(Mail mail) {
		repository.addMail(mail);
	}

	public List<Mail> getInbox(int id) {
		return repository.getInbox(id);
	}

	public List<Mail> getOutbox(int id) {
		return repository.getOutbox(id);
	}

	public void setRepository(MailRepository repository) {
		this.repository = repository;
	}

}
