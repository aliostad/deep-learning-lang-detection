function encryptGroupMessage(message , encryptionKey){
	var encryptedMessage = AESEncryption.encrypt(message , encryptionKey);
	return encryptedMessage;
}

function decryptGroupMessage(cipher , decryptionKey){
	var decryptedMessage = AESEncryption.encrypt(cipher , decryptionKey);
	return decryptedMessage;
}


function encryptInstantMessage(message , encryptionKey){
	var encryptedMessage = RSAEncryption.encrypt(message , encryptionKey , "public");
	return encryptedMessage;
}

function decryptInstantMessage(cipher){
	var decryptedMessage = RSAEncryption.decrypt(cipher , null , "private");
	return decryptedMessage;
}

function encryptPublicMessage(message , encryptionKey){
	var encryptedMessage = AESEncryption.encrypt(message , encryptionKey);
	return encryptedMessage;
}

function decryptPublicMessage(cipher , decryptionKey){
	var decryptedMessage = AESEncryption.decrypt(cipher , decryptionKey);
	return decryptedMessage;
}
