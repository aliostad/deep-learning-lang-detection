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
#        Hash Tests
#
###########################################

Describe "New-GenericHash" {
   Context "no parameter is provided" {
	  It "fails" {
		 { New-GenericHash } | Should Throw
	  }
   }
   Context "message only provided" {
	  It "returns hashed message" {
		 $key = New-Key		 
		 $message = New-GenericHash -Message "This is a test"
		 $message | Should Not BeNullOrEmpty
	  }
   }
   Context "message and keys are provided" {
	  It "returns hashed message" {
		 $key = New-Key		 
		 $message = New-GenericHash -Message "This is a test" -Key $key.key
		 $message | Should Not BeNullOrEmpty
	  }
   }
   Context "advanced options are provided" {
	  It "returns raw hashed message" {
		 $key = New-Key
		 $message = New-GenericHash -Message "This is a test" -Key $key.key -Raw 
		 $message.GetType().Name | Should Be "Byte[]"
	  }
	  It "returns raw hashed message of variable length" {
		 $key = New-Key
		 $message = New-GenericHash -Message "This is a test" -Key $key.key -Raw -HashLength 16
		 $message.length | Should be 16
		 $message.GetType().Name | Should Be "Byte[]"
		 $message = New-GenericHash -Message "This is a test" -Key $key.key -Raw -HashLength 64
	     $message.length | Should be 64
		 $message.GetType().Name | Should Be "Byte[]"
	  }
   }
   Context "file encryption" {
	  It "encrypts file" {
		 rm *.testtxt
		 $key = New-Key
		 "test file" | out-File "testFile.testtxt"
		 $message = New-GenericHash -File "testFile.testtxt" -key $key.key
		 $message| Should Not BeNullOrEmpty
		 rm *.testtxt
	  }
   }
}
