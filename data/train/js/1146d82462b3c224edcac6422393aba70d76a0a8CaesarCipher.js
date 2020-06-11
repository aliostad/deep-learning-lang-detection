cipher = {};

cipher.encrypt = function(message, key) {
  var encryptedMessage = "";

  var message = message.toLowerCase().replace(/ /g, "");

  for (var i = 0; i < message.length; i++ ){
    var encryptedIndex = alphabet.indexOf(message[i]) + key;
    encryptedMessage += alphabet[encryptedIndex % alphabet.length];
  } 

  return encryptedMessage;
}

cipher.decrypt = function(message, key) {
  var decryptedMessage = "";
  var message = message.toLowerCase().replace(/ /g, "");

  for (var i = 0; i < message.length; i++ ){
    var decryptedIndex = Math.abs(alphabet.indexOf(message[i]) - key);
    decryptedMessage += alphabet[decryptedIndex];
  } 

  return decryptedMessage;
}

var alphabet = "abcdefghijklmnopqrstuvwxyz".split("");