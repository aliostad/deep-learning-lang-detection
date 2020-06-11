
function Assert-Arrays-Equal($actual, $expected)
{
	if(!$actual -and $expected)
	{
		"actual  : $actual"
		"expected: $expected"
		throw "Assert-Arrays-Equal - actual is null"
	}
	if(!$expected -and $actual)
	{
		"actual  : $actual"
		"expected: $expected"
		throw "Assert-Arrays-Equal - expected is null"
	}
	if(!$expected -and !$actual)
	{
	}
	else
	{
		$r = Compare-Object $actual $expected
		if($r)
		{
			"actual  : $actual"
			"expected: $expected"
			$r
			throw "Arrays not equal"
		}
	}
}

function Assert-Equal($actual, $expected, $message ='')
{
	if(!($actual -eq $expected))
	{
		"actual  : $actual"
		"expected: $expected"
		if($message)
		{
			throw $message
		}
		else
		{
			throw "expect not equal actual"
		}
	}
}

function Assert
{
	[CmdletBinding(
		SupportsShouldProcess=$False,
		SupportsTransactions=$False,
		ConfirmImpact="None",
		DefaultParameterSetName="")]
  param(
    [Parameter(Position=0,Mandatory=1)]$conditionToCheck,
    [Parameter(Position=1,Mandatory=1)]$failureMessage
  )
  if (!$conditionToCheck) { throw $failureMessage }
}
