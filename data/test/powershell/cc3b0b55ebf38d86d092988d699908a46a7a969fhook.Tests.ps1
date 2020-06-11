$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "hook.ps1" {
	Describe "check_args" {
		It "should return false if at least one parameter is not passed in" {
			$result = check_args 
			$result | Should be $false
		}
		It "should return true if at least one parameter is passed in" {
			$arg1 = "shit"
			$result = check_args $arg1
			$result | Should be $true
		}
		It "should return false if argument is null or empty string" {
			$arg1 = $null
			$result = check_args $arg1
			$result | Should be $false
		}
	}

	Describe "getLastWriteTime" {
		It "should return false if no file is passed in" {
			$result = getLastWriteTime
			$result | Should be $false
		}
		It "should return false if file is empty string" {
			$result = getLastWriteTime ""
			$result | Should be $false
		}
		It "should return the LastWriteTime of a file" {
			$tmpfile = "$pwd\\test$PID.tmp"
			echo "testing" > $tmpfile
			$lwt = (Get-Item $tmpfile).LastWriteTime
			Remove-Item $tmpfile
		}
	}

	Describe "zsnesLoadROM" {
		It "should return false if no file is passed in" {
			$result = zsnesLoadROM
			$result | Should be $false
		}
		It "should return false if file is empty string" {
			$result = zsnesLoadROM ""
			$result | Should be $false
		}

		It "should run the zsnesw.exe" {
			$file = "test"
			Mock Invoke-Expression 

			$result = zsnesLoadROM "$file"

			Assert-MockCalled Invoke-Expression -Times 1
		}
	}
}
