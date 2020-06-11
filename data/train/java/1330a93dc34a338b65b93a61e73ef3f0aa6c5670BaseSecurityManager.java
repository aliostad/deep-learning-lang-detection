package com.yannic.rdv.rest.security;

import org.springframework.beans.factory.annotation.Autowired;

import com.yannic.rdv.data.repository.AccountRepository;
import com.yannic.rdv.data.repository.EventRepository;
import com.yannic.rdv.data.repository.LocationRepository;
import com.yannic.rdv.data.repository.OrganizerRepository;
import com.yannic.rdv.data.repository.PersonRepository;

public class BaseSecurityManager {
	
	@Autowired
	PersonRepository personRepository;
	
	@Autowired
	AccountRepository accountRepository;
	
	@Autowired
	LocationRepository locationRepository;
	
	@Autowired
	EventRepository eventRepository;
	
	@Autowired
	OrganizerRepository organizerRepository;

}
