cd 'C:\Users\Moshe\Documents\visual studio 2013\Projects\Salesforce Api Test\BulkApiUnitTest\bin\Debug\'

ADD-TYPE -Path 'BulkApi.dll'

$UserName = "jewpaltz@gmail.com.uat";
$Password = "";
$SecurityToken = "";


$csv = Get-Content '.\contactsupsert.csv' | out-string
$runner = New-Object -TypeName BulkApi.BatchRunner -ArgumentList $UserName, $Password, $SecurityToken, upsert, "Contact", CSV, $csv, "CMS_Family_ID__c"
$runner.Task.Result

$SOQL = "select FirstName, LastName, Phone from Contact where LastName = 'Plotkin'";
$runner = New-Object -TypeName BulkApi.BatchRunner -ArgumentList $UserName, $Password, $SecurityToken, query, "Contact", CSV, $SOQL, null
$runner.Task.Result
