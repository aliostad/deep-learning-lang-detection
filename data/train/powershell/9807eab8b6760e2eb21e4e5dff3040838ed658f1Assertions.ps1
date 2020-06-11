Add-Type @"
using System;
namespace PScription 
{
    public class AssertionFailedException : Exception 
    { 
        public AssertionFailedException (string msg) : base(msg) { } 
    }
}
"@

function Assert-Equal($expected, $actual, [string]$message = "") {
    Assert-True ($expected -eq $actual) "Expected [$expected] but was [$actual] `n$message"
}

function Assert-NotNull($object) {
    Assert-True ($object -ne $null) "Expected not null but was null"
}

function Assert-True([boolean]$actual, [string]$message) {
    if (-not $actual) {
        throw (New-Object PScription.AssertionFailedException -arg $message)
    }
}
