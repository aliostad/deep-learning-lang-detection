package com.journaldev.spring.service.factory;

import com.journaldev.spring.service.PersonService;

/**
 * Created by sergey on 30.6.17.
 */
public class ServiceFactory {
    private PersonService personService;

    public ServiceFactory(PersonService personService) {
        this.personService = personService;
    }

    public PersonService getPersonService() {
        return personService;
    }

    public void setPersonService(PersonService personService) {
        this.personService = personService;
    }

}
