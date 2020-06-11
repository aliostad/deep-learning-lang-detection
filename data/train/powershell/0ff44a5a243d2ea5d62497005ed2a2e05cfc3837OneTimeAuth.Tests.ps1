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

Describe "New-OneTimeKey" {
   Context "no parameter is provided" {
	  It "creates a new key" {
		 $key = New-OneTimeKey
		 $key.Key | Should Not BeNullOrEmpty
	  }
   }
}

###########################################
#
#        Sign Tests
#
###########################################

Describe "Sign-OneTime" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Sign-OneTime } | Should Throw
	  }
   }
   Context "message and key is provided" {
	  It "creates signed message" {
		 $key = New-OneTimeKey
		 $message = sign-OneTime -Message "This is a test" -Key $key.key
		 $message | Should Not BeNullOrEmpty
	  }
   }
   Context "advanced options are provided" {
	  It "creates raw message" {
		 $key = New-OneTimeKey
		 $message = sign-OneTime -Message "This is a test" -Key $key.key -Raw
		 $message | Should Not BeNullOrEmpty
		 $message.Signature.GetType().Name | Should Be "Byte[]"
		 $message.Signature.Length | Should be 16
	  }
	  It "creates signed message with specified encoding" {
		 $key = New-OneTimeKey
		 $message = sign-OneTime -Message "This is a test" -Key $key.key -Encoding "UTF8"
		 $message | Should Not BeNullOrEmpty
	  }
   }
}

###########################################
#
#        Verify Tests
#
###########################################

Describe "Verify-OneTime" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Verify-OneTime } | Should Throw
	  }
   }
   Context "message and key is provided" {
	  It "verifies signed message" {
		 $key = New-OneTimeKey
		 $message = sign-OneTime -Message "This is a test" -Key $key.key
		 Verify-OneTime -message $message.Message -Key $key.key -Signature $message.Signature | Should be $true
	  }
   }
   Context "advanced options are provided" {
	  It "verifies signed message with specified encoding" {
		 $key = New-OneTimeKey
		 $message = sign-OneTime -Message "This is a test" -Key $key.key -Encoding "UTF8"
		 Verify-OneTime -message $message.Message -Key $key.key -Signature $message.Signature -Encoding "UTF8" | Should be $true
	  }
   }
}

Describe "Verify-RawOneTime" {
   Context "no parameter is provided" {
	  It "fails" {
		 { Verify-RawOneTime } | Should Throw
	  }
   }
   Context "message and key is provided" {
	  It "verifies signed message" {
		 $key = New-OneTimeKey
		 $message = sign-OneTime -Message "This is a test" -Key $key.key -Raw
		 Verify-RawOneTime -message $message.Message -Key $key.key -Signature $message.Signature | Should be $true
	  }
   }
   Context "advanced options are provided" {
	  It "verifies signed message with specified encoding" {
		 $key = New-OneTimeKey
		 $message = sign-OneTime -Message "This is a test" -Key $key.key -Encoding "UTF8" -Raw
		 Verify-RawOneTime -message $message.Message -Key $key.key -Signature $message.Signature -Encoding "UTF8" | Should be $true
	  }
   }
}