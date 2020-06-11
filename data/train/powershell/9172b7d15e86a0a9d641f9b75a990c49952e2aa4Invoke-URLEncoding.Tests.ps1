$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
Import-Module "$here\..\NZB-Powershell" -Force

Describe "Invoke-URLEncoding" {
    It "Encodes &" {
        Invoke-URLEncoding -unencodedString "&" | Should Be "%26"
    }
    It "Encodes Spaces" {
        Invoke-URLEncoding -unencodedString " " | Should Be "+"
    }
    It "Encodes double Quotes" {
        Invoke-URLEncoding -unencodedString "`"" | Should Be "%22"
    }
    It "Encodes Hash" {
        Invoke-URLEncoding -unencodedString "#" | Should Be "%23"
    }
    It "Encodes curly brace" {
        Invoke-URLEncoding -unencodedString "{" | Should Be "%7b"
    }
    It "Encodes HTTPS://" {
        Invoke-URLEncoding -unencodedString "HTTPS://" | Should Be "HTTPS%3a%2f%2f"
    }
    It "Encodes a Dangerous URL" {
        Invoke-URLEncoding -unencodedString "http://example.com/wp-admin/load-scripts.php?c=1&load[]=swfobject,jquery,utils&ver=3.5" | Should Be "http%3a%2f%2fexample.com%2fwp-admin%2fload-scripts.php%3fc%3d1%26load%5b%5d%3dswfobject%2cjquery%2cutils%26ver%3d3.5"
    }
}


