import Ember from 'ember';

export default Ember.Service.extend({
  showQuestionOne: true,
  showQuestionTwo: false,
  showQuestionThree: false,
  showTicketForm: false,
  showTicketConfirmation: false,
  showCloseTicket: false,
  showTicketList: true,
  showTicketDetails: true,

  toggleQuestionOne() {
    if(this.get('showQuestionOne')) {
      this.set('showQuestionOne', false);
    } else {
      this.set('showQuestionOne', true);
    }
  },

  toggleQuestionTwo() {
    if(this.get('showQuestionTwo')) {
      this.set('showQuestionTwo', false);
    } else {
      this.set('showQuestionTwo', true);
    }
  },

  toggleQuestionThree() {
    if(this.get('showQuestionThree')) {
      this.set('showQuestionThree', false);
    } else {
      this.set('showQuestionThree', true);
    }
  },

  toggleTicketForm() {
    if(this.get('showTicketForm')){
      this.set('showTicketForm', false);
    } else {
      this.set('showTicketForm', true);
    }
  },

  toggleTicketConfirmation() {
    if(this.get('showTicketConfirmation')){
      this.set('showTicketConfirmation', false);
    } else {
      this.set('showTicketConfirmation', true);
    }
  },

  toggleCloseTicket() {
    if(this.get('showCloseTicket')){
      this.set('showCloseTicket', false);
    } else {
      this.set('showCloseTicket', true);
    }
  },

  toggleTicketList() {
    if(this.get('showTicketList')){
      this.set('showTicketList', false);
    } else {
      this.set('showTicketList', true);
    }
  },

  toggleTicketDetails() {
    if(this.get('showTicketDetails')){
      this.set('showTicketDetails', false);
    } else {
      this.set('showTicketDetails', true);
    }
  }
});
