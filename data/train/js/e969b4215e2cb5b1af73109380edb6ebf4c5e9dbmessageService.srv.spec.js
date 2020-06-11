// messageService.srv.spec.js

'use strict';

describe('Service: messageService', function () {
  var messageService;
  var ENV;

  beforeEach(function () {
    module('markdownNote');
    module('templates');
  });

  beforeEach(inject(function ($injector) {
    messageService = $injector.get('messageService');
  }));

  describe('Check messageService initialization', function () {

    it('should init all messages to empty string', function () {
      expect(messageService.messages['showAboutMessage']).to.equal('');
      expect(messageService.messages['loadLocalFileMessage']).to.equal('');
      expect(messageService.messages['saveLocalFileMessage']).to.equal('');
      expect(messageService.messages['dropboxWriteMessage']).to.equal('');
      expect(messageService.messages['dropboxReadMessage']).to.equal('');
    });
  });

  describe('clearing messages', function () {
    var tempMessages = {};

    beforeEach(function () {
      tempMessages = angular.copy(messageService.messages);
    });

    afterEach(function () {
      messageService.messages = tempMessages;
    });

    it('should clear clearExtrasModalMessages', function () {
      messageService.messages['showAboutMessage'] = 'test string';
      messageService.messages['loadLocalFileMessage'] = 'test string';
      messageService.messages['saveLocalFileMessage'] = 'test string';

      messageService.clearExtrasModalMessages();

      expect(messageService.messages['showAboutMessage']).to.equal('');
      expect(messageService.messages['loadLocalFileMessage']).to.equal('');
      expect(messageService.messages['saveLocalFileMessage']).to.equal('');
      expect(messageService.messages['dropboxWriteMessage']).to.equal('');
      expect(messageService.messages['dropboxReadMessage']).to.equal('');
    });
  });

  describe('apply message', function () {
    var extrasModal;
    var element;
    var scope;
    var $compile;
    var isolated;
    var modalElement;

    beforeEach(function () {
      inject(function ($injector) {
        $compile = $injector.get('$compile');
        scope = $injector.get('$rootScope').$new();
      });

      element = $compile('<ion-header-bar app-header></ion-header-bar>')(scope);
      scope.$digest();
      isolated = element.isolateScope();
      angular.element(document).find('body').append(element); // for rendering css
      extrasModal = isolated.ctrl.extrasModal;
      modalElement = extrasModal.$el;
    });

    it('should apply message', function () {
      var messageContainer = modalElement.find('#dropboxReadMessageCard div h3');
      var tempMessage = messageContainer.text();
      messageService.applyMessage({
        messageType: 'dropboxReadMessage',
        message: 'test message'
      });
      expect(messageContainer.text()).to.equal('test message');
      messageContainer.text(tempMessage);
    });

    it('should get message', function () {
      var messageType = 'dropboxReadMessage';
      var tempMessage = messageService.messages[messageType];
      messageService.messages[messageType] = 'test get message';
      expect(messageService.getMessage({messageType: messageType}))
        .to.equal('test get message');
      messageService.messages[messageType] = tempMessage;
    });

    it('should set message', function () {
      var messageType = 'dropboxReadMessage';
      var tempMessage = messageService.messages[messageType];
      messageService.setMessage({
        messageType: messageType,
        message: 'test get message'
      });
      expect(messageService.messages[messageType])
        .to.equal('test get message');
      messageService.messages[messageType] = tempMessage;
    });
  });
});

