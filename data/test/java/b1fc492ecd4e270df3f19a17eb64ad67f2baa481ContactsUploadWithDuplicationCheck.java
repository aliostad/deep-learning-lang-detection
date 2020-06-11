package com.crm.contact.service.imp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.crm.contact.service.ContactService;
import com.crm.contact.service.StateService;
import com.crm.service.CrmEmailService;

@Service
@Transactional
public class ContactsUploadWithDuplicationCheck {
	ContactService contactService;
	StateService stateService;
	CrmEmailService crmEmailService;

	@Autowired
	public ContactsUploadWithDuplicationCheck(ContactService contactService, StateService stateService,
			CrmEmailService crmEmailService) {
		super();
		this.contactService = contactService;
		this.stateService = stateService;
		this.crmEmailService = crmEmailService;
	}

}
