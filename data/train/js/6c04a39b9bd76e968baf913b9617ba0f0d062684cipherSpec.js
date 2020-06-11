describe("Caesar Cipher", function(){
  var message;
  var encryptedMessage;

  beforeEach(function(){
    message = "attackatdawn";
    encryptedMessage = "buubdlbuebxo";
  });

  it("encrypts a message", function(){
    expect(encrypt(message,1))
      .toEqual(encryptedMessage);
  });

  it("doesn't overrun the alphabet", function(){
    expect(encrypt(message, 27)).toEqual(encryptedMessage);
  });


  it("decrypts a message", function(){
    expect(decrypt(encryptedMessage,11))
      .toEqual(message);
  });
});