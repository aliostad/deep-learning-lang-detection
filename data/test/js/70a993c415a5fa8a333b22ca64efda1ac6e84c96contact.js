import {inject} from 'aurelia-framework';
import {ContactService} from '../services/contactService';
import {HttpClient} from 'aurelia-http-client';
import {AuthenticationService} from '../services/AuthenticationService';
import {UserService} from '../services/userservice'
import {Router} from 'aurelia-router';

@inject(ContactService, HttpClient, AuthenticationService, UserService, Router)
export class Contact {

  constructor(contactService, http, authSerice, userService, router) {
    this.contactService = contactService;
    this.http = http;
    this.authService = authSerice;
    this.userService = userService;
    this.router = router;

    this.user = {};

    this.userService.getProfile().then(user => {
      this.user = user;
      this.my_contacts = [];

      this.contactService.getMyContacts(user.id).then(contacts => {
        this.my_contacts = contacts;
      });
    });
  }



}
