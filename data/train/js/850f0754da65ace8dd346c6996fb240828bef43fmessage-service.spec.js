
describe('MessageService', function(){
  var MessageService;

  beforeEach(module('everycent'));
  beforeEach(inject(function(_MessageService_){
    MessageService = _MessageService_;
  }));

  it('can set a message', function(){
    MessageService.setMessage('My message');
    expect(MessageService.getMessageData().message).toEqual('My message');
  });

  it('can clear messages', function(){
    MessageService.setMessage('My message');
    expect(MessageService.getMessageData().message).toEqual('My message');

    MessageService.clearMessage();
    expect(MessageService.getMessageData().message).toEqual('');
  });
});
