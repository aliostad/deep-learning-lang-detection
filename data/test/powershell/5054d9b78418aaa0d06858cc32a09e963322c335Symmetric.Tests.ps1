if (-not (get-Module PoSH-Sodium))
{
	if (($env:sodiumBuild) -and $env:sodiumBuild -eq "Release")
	{
		import-Module "$pwd\..\PoSH-Sodium\bin\Release\PoSH-Sodium.dll"
	}
	else
	{
		import-Module "$pwd\..\PoSH-Sodium\bin\Debug\PoSH-Sodium.dll"
	}
}

###########################################
#
#        GenerateKey Tests
#
###########################################

Describe "New-Key" {
   Context "no parameter is provided" {
	  It "creates a new key" {
		 $key = New-Key
		 $key.key | Should Not BeNullOrEmpty
	  }
   }
}

###########################################
#
#        Encrypt Tests
#
###########################################

Describe "Encrypt-SymmetricMessage" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Encrypt-SymmetricMessage } | Should Throw
	  }
   }
   Context "message and keys are provided" {
	  It "returns encrypted message" {
		 $key = New-Key		 
		 $message = Encrypt-SymmetricMessage -Message "This is a test" -Key $key.key
		 $message | Should Not BeNullOrEmpty
	  }
	  It "returns chacha encrypted message" {
		 $key = New-Key		 
		 $message = Encrypt-SymmetricMessage -Message "This is a test" -Key $key.key -Type ChaCha20
		 $message | Should Not BeNullOrEmpty
	  }
	  It "returns xsalsa encrypted message" {
		 $key = New-Key		 
		 $message = Encrypt-SymmetricMessage -Message "This is a test" -Key $key.key -Type XSalsa20
		 $message | Should Not BeNullOrEmpty
	  }
   }
   Context "file encryption" {
	  It "encrypts file" {
		 rm *.testtxt
		 $key = New-Key
		 "test file" | out-File "testFile.testtxt"
		 $message = Encrypt-SymmetricMessage -File "testFile.testtxt" -Key $key.key -OutFile EncryptFile.testtxt
		 $(test-path EncryptFile.testtxt) | Should be $true
		 rm *.testtxt
	  }
	  It "encrypts file with chacha" {
		 rm *.testtxt
		 $key = New-Key
		 "test file" | out-File "testFile.testtxt"
		 $message = Encrypt-SymmetricMessage -File "testFile.testtxt" -Key $key.key -OutFile EncryptFile.testtxt -Type "ChaCha20"
		 $(test-path EncryptFile.testtxt) | Should be $true
		 rm *.testtxt
	  }
	  It "encrypts file with xsalsa" {
		 rm *.testtxt
		 $key = New-Key
		 "test file" | out-File "testFile.testtxt"
		 $message = Encrypt-SymmetricMessage -File "testFile.testtxt" -Key $key.key -OutFile EncryptFile.testtxt -Type "XSalsa20"
		 $(test-path EncryptFile.testtxt) | Should be $true
		 rm *.testtxt
	  }
   }
}


###########################################
#
#        Sign Tests
#
###########################################

Describe "Sign-SymmetricMessage" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Sign-SymmetricMessage } | Should Throw
	  }
   }
   Context "message and key is provided" {
	  It "creates signed message" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key
		 $message | Should Not BeNullOrEmpty
	  }
   }
   Context "advanced options are provided" {
	  It "creates raw message" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -Raw
		 $message | Should Not BeNullOrEmpty
		 $message.Signature.GetType().Name | Should Be "Byte[]"
		 $message.Signature.Length | Should be 32
	  }
	  It "creates signed message with specified encoding" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -Encoding "UTF8"
		 $message | Should Not BeNullOrEmpty
	  }
	  It "Creates signed message with HmacSha512" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -HashType HmacSha512
		 $message | Should Not BeNullOrEmpty
	  }
	  It "Creates signed message with HmacSha256" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -HashType HmacSha256
		 $message | Should Not BeNullOrEmpty
	  }
   }
}

###########################################
#
#        Verify Tests
#
###########################################

Describe "Verify-SymmetricMessage" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Verify-SymmetricMessage } | Should Throw
	  }
   }
   Context "message and key is provided" {
	  It "verifies signed message" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key
		 Verify-SymmetricMessage -message $message.Message -Key $key.key -Signature $message.Signature | Should be $true
	  }
   }
   Context "advanced options are provided" {
	  It "verifies signed message with specified encoding" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -Encoding "UTF8"
		 Verify-SymmetricMessage -message $message.Message -Key $key.key -Signature $message.Signature -Encoding "UTF8" | Should be $true
	  }
	  It "verifies signed message with HmacSha512" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -HashType HmacSha512
		 Verify-SymmetricMessage -message $message.Message -Key $key.key -Signature $message.Signature -HashType HmacSha512 | Should be $true
	  }
	  It "verifies signed message with HmacSha256" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -HashType HmacSha256
		 Verify-SymmetricMessage -message $message.Message -Key $key.key -Signature $message.Signature -HashType HmacSha256 | Should be $true
	  }
   }
}

Describe "Verify-RawSymmetricMessage" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Verify-RawSymmetricMessage } | Should Throw
	  }
   }
   Context "message and key is provided" {
	  It "verifies signed message" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -Raw
		 Verify-RawSymmetricMessage -message $message.Message -Key $key.key -Signature $message.Signature | Should be $true
	  }
   }
   Context "advanced options are provided" {
	  It "verifies signed message with specified encoding" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -Encoding "UTF8" -Raw
		 Verify-RawSymmetricMessage -message $message.Message -Key $key.key -Signature $message.Signature -Encoding "UTF8" | Should be $true
	  }
	  It "verifies signed message with HmacSha512" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -HashType HmacSha512 -Raw
		 Verify-RawSymmetricMessage -message $message.Message -Key $key.key -Signature $message.Signature -HashType HmacSha512 | Should be $true
	  }
	  It "verifies signed message with HmacSha256" {
		 $key = New-Key
		 $message = sign-SymmetricMessage -Message "This is a test" -Key $key.key -HashType HmacSha256 -Raw
		 Verify-RawSymmetricMessage -message $message.Message -Key $key.key -Signature $message.Signature -HashType HmacSha256 | Should be $true
	  }
   }
}

###########################################
#
#        Decrypt Tests
#
###########################################

Describe "Decrypt-SymmetricMessage" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Decrypt-SymmetricMessage } | Should Throw
	  }
   }
   Context "message and keys are provided" {
	  It "returns decrypted message" {
		 $key = New-Key		 
		 $secretMessage = Encrypt-SymmetricMessage -Message "This is a test" -Key $key.key
		 $message = Decrypt-SymmetricMessage -Message $secretMessage.Message -key $key.key -Nonce $secretMessage.Nonce
		 $message | Should be "This is a test"
	  }
	  It "returns chacha decrypted message" {
		 $key = New-Key		 
		 $secretMessage = Encrypt-SymmetricMessage -Message "This is a test" -Key $key.key -Type ChaCha20
		 $message = Decrypt-SymmetricMessage -Message $secretMessage.Message -key $key.key -Nonce $secretMessage.Nonce -Type ChaCha20
		 $message | Should be "This is a test"
	  }
	  It "returns xsalsa decrypted message" {
		 $key = New-Key		 
		 $secretMessage = Encrypt-SymmetricMessage -Message "This is a test" -Key $key.key -Type XSalsa20
		 $message = Decrypt-SymmetricMessage -Message $secretMessage.Message -key $key.key -Nonce $secretMessage.Nonce -Type XSalsa20
		 $message | Should be "This is a test"
	  }
	  It "returns decrypted message per encoding" {
		 $key = New-Key		 
		 $secretMessage = Encrypt-SymmetricMessage -Message "This is a test" -key $key.key -Encoding "UTF8"
		 $message = Decrypt-SymmetricMessage -Message $secretMessage.Message -key $key.key -Nonce $secretMessage.Nonce -Encoding "UTF8"
		 $message | Should be "This is a test"
	  }
   }
   Context "file decryption" {
	  It "decrypts file" {
	    rm *.testtxt
		$key = New-Key
		"test file" | out-File "testFile.testtxt"
		Encrypt-SymmetricMessage -File "testFile.testtxt" -Key $key.key -OutFile EncryptFile.testtxt
		$(test-path EncryptFile.testtxt) | Should be $true
		Decrypt-SymmetricMessage -File "EncryptFile.testtxt" -Key $key.key -OutFile DecryptFile.testtxt
		$(cat DecryptFile.testtxt) | Should be "test file"
		rm *.testtxt
	  }
	  It "chacha decrypts file" {
	    rm *.testtxt
		$key = New-Key
		"test file" | out-File "testFile.testtxt"
		Encrypt-SymmetricMessage -File "testFile.testtxt" -Key $key.key -OutFile EncryptFile.testtxt -Type ChaCha20
		$(test-path EncryptFile.testtxt) | Should be $true
		Decrypt-SymmetricMessage -File "EncryptFile.testtxt" -Key $key.key -OutFile DecryptFile.testtxt -Type ChaCha20
		$(cat DecryptFile.testtxt) | Should be "test file"
		rm *.testtxt
	  }
	  It "xsalsa decrypts file" {
	    rm *.testtxt
		$key = New-Key
		"test file" | out-File "testFile.testtxt"
		Encrypt-SymmetricMessage -File "testFile.testtxt" -Key $key.key -OutFile EncryptFile.testtxt -Type XSalsa20
		$(test-path EncryptFile.testtxt) | Should be $true
		Decrypt-SymmetricMessage -File "EncryptFile.testtxt" -Key $key.key -OutFile DecryptFile.testtxt -Type XSalsa20
		$(cat DecryptFile.testtxt) | Should be "test file"
		rm *.testtxt
	  }
   }
}