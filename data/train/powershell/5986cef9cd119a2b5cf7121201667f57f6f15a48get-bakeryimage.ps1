param([int]$Provider,[string]$CommonName,[int]$ImageType)

#For testing



Add-Type @"
using System;public class ImageRequest{ public string CommonName {get;set;}public int ImageType {get;set;} public int Provider {get;set;} } 
"@



$r=invoke-restmethod -URI "http://hercules/bakery/api/image/?CommonName=${CommonName}&ImageType=${ImageType}&Provider=${Provider}" -Method Get
#$r=invoke-restmethod -URI "http://localhost:65316/api/image/?CommonName=${CommonName}&ImageType=${ImageType}&Provider=${Provider}" -Method Get
$r