// describe("Cipher", function(){
//   it("encrypts a message", function(){
//     expect(encrypt("attackatdown", "lemon")).toEqual("lxfopvefrnhr");
//   });
// });

describe("Cesar Cipher", function(){
  var message;
  var encryptedMessage;

  beforeEach(function(){
    message = "attackatdawn";
    encryptedMessage = "leelnvleolhy";
  });


  it("encrypts a message", function(){
    expect(encrypt("message",11))
      .toEqual(encryptedMessage);
  });

  //   afterEach(function(){
  //   message = "attackatdawn";
  //   encryptedMessage = "leelnvleolhy";
  // });

  it("decrypts a message", function(){
    expect(decrypt(encryptedMessage,11))
      .toEqual("message");
  });
});