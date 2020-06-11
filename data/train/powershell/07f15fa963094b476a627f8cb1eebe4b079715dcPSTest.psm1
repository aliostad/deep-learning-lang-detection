<# 
psTest v0.01
Copyright © 2009 Jorge Matos
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
#>

#Load up System.Transactions in case we need to rollback any database changes
[void][Reflection.Assembly]::Load("System.Transactions, version=2.0.0.0, Culture=neutral, publickeytoken=b77a5c561934e089")

#Variables
#This hashtable holds all the tests from the file passed into Invoke-Tests
[Hashtable]$Tests = @{}

#This variable controls whether or not Invoke-Tests uses the "exit" function
#	to exit powershell with the exit code = number of failed tests. This
#	makes it usable from integration servers like CruiseControl or Hudson
[bool]$PSTest_ReturnExitCode=$false

Export-ModuleMember -Variable PSTest_ReturnExitCode

function Assert([bool]$condition, [string]$message)
{
	$exceptionMessage = "Test Failed"
	if (![string]::IsNullOrEmpty($message))
	{
		$exceptionMessage = $message
	}
	if (!$condition)
	{
		throw $exceptionMessage
	}
}

Export-ModuleMember -Function Assert

function AssertFail([string]$message)
{
	$exceptionMessage = ""
	if (![string]::IsNullOrEmpty($message))
	{
		$exceptionMessage = $message
	}
	Assert $fail $exceptionMessage
}

Export-ModuleMember -Function AssertFail

function AssertAreEqual($actual, $expected, $message)
{
	$exceptionMessage = "Expected: $expected But was: $actual"
	if (![string]::IsNullOrEmpty($message))
	{
		$exceptionMessage += "`nMessage: " + $message
	}
	Assert $actual -EQ $expected $exceptionMessage
}

Export-ModuleMember -Function AssertAreEqual

function AssertGreaterThan($actual, $value, $message)
{	
	$exceptionMessage = "Length was not greater than $value but was $actual"
	if (![string]::IsNullOrEmpty($message))
	{
		$exceptionMessage += "`nMessage: " + $message
	}
	Assert $actual -GT $value $exceptionMessage
}

function AssertLessThan($actual, $value, $message)
{	
	$exceptionMessage = "Length was not less than $value but was $actual"
	if (![string]::IsNullOrEmpty($message))
	{
		$exceptionMessage += "`nMessage: " + $message
	}
	Assert $actual -LT $value $exceptionMessage
}

function Test([string]$name, [ScriptBlock]$test, [Switch]$ShouldRollBack)
{
	$testobj = "" | select Name, Test, ShouldRollBack
	$testobj.Name = $name
	$testobj.Test = $test
	$testobj.ShouldRollBack = $ShouldRollBack
	$Tests.$name = $testobj
}

Export-ModuleMember -Function Test

function Invoke-Tests([string]$testFile)
{
	$failedTests = @()
	. $testFile
	[int]$total = $Tests.Count
	[int]$failed = 0
	foreach($testName in $Tests.Keys)
	{		
		$testObj = $Tests[$testName]
		try
		{
			if ($testobj.ShouldRollBack)
			{
				$ts = New-Object System.Transactions.TransactionScope
				try
				{
					&$testobj.Test
				}
				finally
				{
					$ts.Dispose()
				}
			}
			else
			{
				&$testobj.Test
			}			
			[System.Console]::Write(".")
		}
		catch
		{
			$failedTests += "Test: $testName Failed`n$_"
			$failed++
			[System.Console]::Write("F")
		}
		$passed = $total - $failed		
	}
	""	
	foreach ($failedTest in $failedTests)
	{
		"$failedTest`n"
	}
	"Total: {0} Passed: {1} Failed: {2}" -F $total, $passed, $failed 
	
	if ($PSTest_ReturnExitCode)
	{
		exit $failed
	}
}

Export-ModuleMember -Function Invoke-Tests

New-Alias its Invoke-Tests

Export-ModuleMember -Alias its