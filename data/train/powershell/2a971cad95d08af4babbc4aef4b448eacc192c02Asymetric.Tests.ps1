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
#        GenerateKeyPair Tests
#
###########################################

Describe "New-KeyPair" {
   Context "no parameter is provided" {
	  It "creates a new keypair" {
		 $key = New-KeyPair
		 $key.PublicKey | Should Not BeNullOrEmpty
		 $key.PrivateKey | Should Not BeNullOrEmpty
	  }
   }
   Context "seed is provided" {
	  It "fails for bad seed" {
		 [byte[]]$seed = 1..20|%{$_}
		 { New-KeyPair -Seed $seed } | Should Throw
	  }
	  It "creates keypair for good seed" {
		 [byte[]]$seed = 1..32|%{$_}
		 { New-KeyPair -Seed $seed } | Should Not Throw
		 $key = New-KeyPair -Seed $seed
		 $key.PublicKey | Should Not BeNullOrEmpty
		 $key.PrivateKey | Should Not BeNullOrEmpty
	  }
   }
}

Describe "New-CurveKeyPair" {
	Context "no parameter is provided" {
		It "creates a new keypair" {
			$key = New-CurveKeyPair
			$key.PublicKey | Should Not BeNullOrEmpty
		    $key.PrivateKey | Should Not BeNullOrEmpty
		}
	}
	Context "seed is provided" {
	  It "fails for bad seed" {
		 [byte[]]$seed = 1..20|%{$_}
		 { New-CurveKeyPair -PrivateKey $seed } | Should Throw
	  }
	  It "creates keypair for good seed" {
		 [byte[]]$seed = 1..32|%{$_}
		 { New-CurveKeyPair -PrivateKey $seed } | Should Not Throw
		 $key = New-CurveKeyPair -PrivateKey $seed
		 $key.PublicKey | Should Not BeNullOrEmpty
		 $key.PrivateKey | Should Not BeNullOrEmpty
	  }
   }
}


###########################################
#
#        Sign Tests
#
###########################################


Describe "Sign-Message" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Sign-Message } | Should Throw
	  }
   }
   Context "message and key is provided" {
	  It "creates signed message" {
		 $key = New-KeyPair
		 $message = sign-Message -Message "This is a test" -PrivateKey $key.PrivateKey
		 $message | Should Not BeNullOrEmpty
	  }
   }
   Context "advanced options are provided" {
	  It "creates raw message" {
		 $key = New-KeyPair
		 $message = sign-Message -Message "This is a test" -PrivateKey $key.PrivateKey -Raw
		 $message | Should Not BeNullOrEmpty
		 $message.GetType().Name | Should Be "Byte[]"
	  }
	  It "creates signed message with specified encoding" {
		 $key = New-KeyPair
		 $message = sign-Message -Message "This is a test" -PrivateKey $key.PrivateKey -Encoding "UTF8"
		 $message | Should Not BeNullOrEmpty
	  }
   }
}


###########################################
#
#        Verify Tests
#
###########################################

Describe "Verify-Message" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Verify-Message } | Should Throw
	  }
   }
   Context "signed message and key is provided" {
	  It "returns plain text message" {
		 $key = New-KeyPair
		 $message = sign-Message -Message "This is a test" -PrivateKey $key.PrivateKey
		 verify-Message -Message $message -PublicKey $key.PublicKey | Should Be "This is a test"
	  }
   }
   Context "advanced options are provided" {
	  It "returns raw message" {
		 $key = New-KeyPair
		 $message = sign-Message -Message "This is a test" -PrivateKey $key.PrivateKey
		 (verify-Message -Message $message -PublicKey $key.PublicKey -Raw).GetType().Name | Should Be "Byte[]"
	  }
	  It "verifies signed message with specified encoding" {
		 $key = New-KeyPair
		 $message = sign-Message -Message "This is a test" -PrivateKey $key.PrivateKey -Encoding "UTF8"
		 verify-Message -Message $message -PublicKey $key.PublicKey -Encoding "UTF8" | Should Be "This is a test"
	  }
   }
}

Describe "Verify-RawMessage" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Verify-Message } | Should Throw
	  }
   }
   Context "signed message and key is provided" {
	  It "returns plain text message" {
		 $key = New-KeyPair
		 $message = sign-Message -Message "This is a test" -PrivateKey $key.PrivateKey -Raw 
		 verify-RawMessage -Message $message -PublicKey $key.PublicKey | Should Be "This is a test"
	  }
   }
   Context "advanced options are provided" {
	  It "returns raw message" {
		 $key = New-KeyPair
		 $message = sign-Message -Message "This is a test" -PrivateKey $key.PrivateKey -Raw 
		 (verify-RawMessage -Message $message -PublicKey $key.PublicKey -Raw).GetType().Name | Should Be "Byte[]"
	  }
	  It "verifies signed message with specified encoding" {
		 $key = New-KeyPair
		 $message = sign-Message -Message "This is a test" -PrivateKey $key.PrivateKey -Raw -Encoding "UTF8"
		 verify-RawMessage -Message $message -PublicKey $key.PublicKey -Encoding "UTF8" | Should Be "This is a test"
	  }
   }
}

###########################################
#
#        Key Convert Tests
#
###########################################

Describe "ConvertTo-CurveKey" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Convert-PublicKey } | Should Throw
	  }
   }
   Context "Ed25519 key pair converted to Curve25519 key pair" {
	  It "returns converted key" {
		 $key = New-KeyPair
		 { ConvertTo-CurveKey $key } | Should Not Throw
	  }
   }
   Context "Ed25519 public key converted to Curve25519 public key" {
	  It "returns converted key" {
		 $key = New-KeyPair
		 { ConvertTo-CurveKey $key.GetPublicKey() } | Should Not Throw
	  }
   }
   Context "Ed25519 private key converted to Curve25519 private key" {
	  It "returns converted key" {
		 $key = New-KeyPair
		 { ConvertTo-CurveKey $key.GetPrivateKey() } | Should Not Throw
	  }
   }
}

###########################################
#
#        Encrypt Tests
#
###########################################

Describe "Encrypt-Message" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Encrypt-Message } | Should Throw
	  }
   }
   Context "message and keys are provided" {
	  It "returns encrypted message" {
		 $key = New-CurveKeyPair		 
		 $message = Encrypt-Message -Message "This is a test" -PublicKey $key.PublicKey -PrivateKey $key.PrivateKey
		 $message | Should Not BeNullOrEmpty
	  }
   }
   Context "encryption after Ed25519 key conversion" {
	  It "returns encrypted message" {
		 $key = New-KeyPair
		 $curveKey = ConvertTo-CurveKey	 $key
		 $message = Encrypt-Message -Message "This is a test" -PublicKey $curveKey.publicKey -PrivateKey $curveKey.privateKey
		 $message | Should Not BeNullOrEmpty
	  }
   }
   Context "file encryption" {
	  It "encrypts file" {
		 rm *.testtxt
		 $key = New-CurveKeyPair
		 "test file" | out-File "testFile.testtxt"
		 $message = Encrypt-Message -File "testFile.testtxt" -PublicKey $key.PublicKey -PrivateKey $key.PrivateKey -OutFile EncryptFile.testtxt
		 $(test-path EncryptFile.testtxt) | Should be $true
		 rm *.testtxt
	  }
   }
}

###########################################
#
#        Decrypt Tests
#
###########################################

Describe "Decrypt-Message" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Decrypt-Message } | Should Throw
	  }
   }
   Context "message and keys are provided" {
	  It "returns decrypted message" {
		 $key = New-CurveKeyPair		 
		 $secretMessage = Encrypt-Message -Message "This is a test" -PublicKey $key.PublicKey -PrivateKey $key.PrivateKey
		 $message = Decrypt-Message -Message $secretMessage.Message -PublicKey $key.PublicKey -PrivateKey $key.PrivateKey -Nonce $secretMessage.Nonce
		 $message | Should be "This is a test"
	  }
	  It "returns decrypted message per encoding" {
		 $key = New-CurveKeyPair		 
		 $secretMessage = Encrypt-Message -Message "This is a test" -PublicKey $key.PublicKey -PrivateKey $key.PrivateKey -Encoding "UTF8"
		 $message = Decrypt-Message -Message $secretMessage.Message -PublicKey $key.PublicKey -PrivateKey $key.PrivateKey -Nonce $secretMessage.Nonce -Encoding "UTF8"
		 $message | Should be "This is a test"
	  }
   }
   Context "decryption after Ed25519 key conversion" {
	  It "returns encrypted message" {
		 $key = New-KeyPair
		 $curveKey = $key | ConvertTo-CurveKey	 
		 $secretMessage = Encrypt-Message -Message "This is a test" -PublicKey $curveKey.publicKey -PrivateKey $curveKey.privateKey
		 $message = Decrypt-Message -Message $secretMessage.Message -PublicKey $curveKey.publicKey -PrivateKey $curveKey.privateKey -Nonce $secretMessage.Nonce
		 $message| Should be "This is a test"
	  }
   }
   Context "file decryption" {
	  It "decrypts file" {
	    rm *.testtxt
		$key = New-CurveKeyPair
		"test file" | out-File "testFile.testtxt"
		Encrypt-Message -File "testFile.testtxt" -PublicKey $key.PublicKey -PrivateKey $key.PrivateKey -OutFile EncryptFile.testtxt
		$(test-path EncryptFile.testtxt) | Should be $true
		Decrypt-Message -File "EncryptFile.testtxt" -PublicKey $key.PublicKey -PrivateKey $key.PrivateKey -OutFile DecryptFile.testtxt
		$(cat DecryptFile.testtxt) | Should be "test file"
		rm *.testtxt
	  }
   }
}