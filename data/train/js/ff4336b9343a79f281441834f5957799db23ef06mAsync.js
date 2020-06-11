
mAsync = {
	
	pgp_genKeyPair: function(callback) { mDispatch.dispatch('pgp_genKeyPair', arguments); },
	pgp_getPrivateKey: function(callback) { mDispatch.dispatch('pgp_getPrivateKey', arguments); },
	pgp_getPublicKey: function(callback) { mDispatch.dispatch('pgp_getPublicKey', arguments); },
	
	rsa_genKeyPair: function(callback) { mDispatch.dispatch('rsa_genKeyPair', arguments); },
	rsa_getPrivateKey: function(callback) { mDispatch.dispatch('rsa_getPrivateKey', arguments); },
	rsa_getPublicKey: function(callback) { mDispatch.dispatch('rsa_getPrivateKey', arguments); },
	sha256_hash: function(callback, bytes64) { mDispatch.dispatch('sha256_hash', arguments); },
	sha1_hash: function(callback, bytes64) { mDispatch.dispatch('sha1_hash', arguments); },
	sha1_hmac: function(callback, key64, bytes64) { mDispatch.dispatch('sha1_hmac', arguments); },
	zip_inflate: function(callback, data64) { mDispatch.dispatch('zip_inflate', arguments); },
	zip_deflate: function(callback, data64) { mDispatch.dispatch('zip_deflate', arguments); },
	aes_encrypt: function(callback, key64, iv64, bytes64) { mDispatch.dispatch('aes_encrypt', arguments); },
	aes_decrypt: function(callback, key64, iv64, bytes64) { mDispatch.dispatch('aes_decrypt', arguments); },
	pbe_genKey: function(callback, password, salt64, iterationCount, keyLength) { mDispatch.dispatch('pbe_genKey', arguments); },
	
	rsa_encrypt: function(callback, key, bytes64) { 
		if (mDispatch.mode == 'native')
			mDispatch.dispatch('rsa_encrypt_serialized_key', [callback, hex2b64(key.genX509()), bytes64]); 
		else
			mDispatch.dispatch('rsa_encrypt_serialized_key', [callback, key.serialize(), bytes64]); 
	},

	rsa_decrypt: function(callback, key, bytes64) { 
		if (mDispatch.mode == 'native')
			mDispatch.dispatch('rsa_decrypt_serialized_key', [callback, hex2b64(key.genPKCS1()), bytes64]); 
		else
			mDispatch.dispatch('rsa_decrypt_serialized_key', [callback, key.serialize(), bytes64]); 
	},
	
	pgp_encrypt: function(callback, key, bytes64) { 
		mDispatch.dispatch('pgp_encrypt_serialized_key', [callback, key.serialize(), bytes64]); 
	},

	pgp_decrypt: function(callback, key, bytes64) { 
		mDispatch.dispatch('pgp_decrypt_serialized_key', [callback, key.serialize(), bytes64]); 
	},
	
	srp_dispatch: function(cmd, callback, state, arg) {
		var originalCallback = callback;
		var originalState = state;
		var srpCallback = {
			invoke: function(data) {
				if (data instanceof Error)
				{
				}
				else
				{
					var newState = data;
					if (newState != originalState)
						for (var i in newState)
							originalState[i] = newState[i];
				}
				originalCallback.invoke(data);
			}
		};

		mDispatch.dispatch(cmd, [srpCallback, state, arg]);
	},

	srp_client_setSalt: function(callback, state, arg) { mAsync.srp_dispatch('srp_client_setSalt',callback, state, arg); },
	srp_client_setServerPublicKey: function(callback, state, arg) { mAsync.srp_dispatch('srp_client_setServerPublicKey',callback, state, arg); },
	srp_client_validateServerEvidence: function(callback, state, arg) { mAsync.srp_dispatch('srp_client_validateServerEvidence',callback, state, arg); },

	ping: function()
	{
		return 'ping';
	}
	
} ;

