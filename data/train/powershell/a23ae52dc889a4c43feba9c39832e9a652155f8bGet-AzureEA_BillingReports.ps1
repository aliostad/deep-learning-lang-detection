#Created by: Kevin Sapp, Modifyed by : Masahiko Ebisuda
#Date: 2/1/2016
#Description: This script downloads the Azure billing reports for a particular month.  
#Requirements: Access to the Enterprise Agreement Portal - https://ea.azure.com/ to collect the Accesskey and Enrollment number

#Configuration
Param(
 [string]$EnrollmentNo,
 [string]$Accesskey,
 [string]$Month,
 [string]$OutPutDir
)

$baseurl = "https://ea.azure.com/"
$baseurlRest = "https://ea.azure.com/rest/"
[string]$Month = ([datetime]$Month).ToString("yyyy-MM")   #Change date format to YYYY-MM

#### UNCOMMENT for manual entry of Accesskey and Enrollment number
#Get the Azure Billing Enrollment Number from ea.azure.com under Manage->Enrollment Number
#$enrollmentNo ="<REPLACE WITH ENROLLMENT NUMBER>"
#Get the Accesskey from ea.azure.com under Reports->Download Usage->API Access Key. Create a new Access key if needed.
#$accesskey = "<REPLACE WITH LONG ACCESS KEY>"
#Change Month of the report - Use YYYY-MM date format
#$month = "2015-07" 


$authHeaders = @{"authorization"="bearer $accesskey";"api-version"="1.0"}
#Export Azure Billing Report filename and locations
$filename_detailRpt = "$OutPutDir\Azure-Billing_UsageData-Details_Month-$month-" + (Get-Date).ToString('yyyyMMddHHmmss') + ".csv"
$filename_priceRpt = "$OutPutDir\Azure-Billing_UsageData-Price_Month-$month-" + (Get-Date).ToString('yyyyMMddHHmmss') + ".csv"
$filename_summaryRpt = "$OutPutDir\Azure-Billing_UsageData-Summary_Month-$month-" + (Get-Date).ToString('yyyyMMddHHmmss') + ".csv"

Try{
#Get all usage reports
Write-Host "Gathering billing Reports for Month: $month ..." -ForegroundColor Green
$url= $baseurlRest + $enrollmentNo + "/usage-reports"
$sResponse = Invoke-WebRequest $url -Headers $authHeaders 
$sContent = $sResponse.Content | ConvertFrom-Json

#Get Download links for $month
$downloadlinks = $sContent.AvailableMonths | Where{$_.Month -eq $month}

if ($downloadlinks){
$downloadDetailReport = $downloadlinks.LinkToDownloadDetailReport 
$downloadPriceReport = $downloadlinks.LinkToDownloadPriceSheetReport
$downloadSummaryReport = $downloadlinks.LinkToDownloadSummaryReport
 
Write-Host "Downloading Azure Billing Reports..." -ForegroundColor Green
$url_DetailReport = $baseurl + $downloadDetailReport
$url_PriceReport = $baseurl + $downloadPriceReport
$url_SummaryReport = $baseurl + $downloadSummaryReport

#Start downloading the Reports
# Details Report
Invoke-WebRequest $url_DetailReport -Headers $authHeaders -OutFile $filename_detailRpt
# Price Report
Invoke-WebRequest $url_PriceReport -Headers $authHeaders -OutFile $filename_priceRpt
# Summary Report
Invoke-WebRequest $url_SummaryReport -Headers $authHeaders -OutFile $filename_summaryRpt

Write-Host "Finished Downloading the Azure Billing Reports..." -ForegroundColor Green 
Write-Host "Completed Sucessfully!" -ForegroundColor Green
}
else{
Write-Host "Error: Unable to get the download links for Month: $month!" -ForegroundColor Red
}
 }
Catch [System.Exception]
{
	$loopLine =  $_.InvocationInfo.ScriptLineNumber;
	$loopEx = $_.Exception;
	$errMessage = "Exception at line $loopLine message: $loopEx"
	Write-Host $errMessage -ForegroundColor Red		
} #end Catch


#deleting meaningless 2 rows
$text = Get-Content $filename_detailRpt
$text[0] = $null
$text[1] = $null
$text | Out-File $filename_detailRpt

$text = Get-Content $filename_priceRpt
$text[0] = $null
$text[1] = $null
$text | Out-File $filename_priceRpt



#place latest usage data file
$latestFilename = "$OutPutDir\Azure-Billing_UsageData-Details_latest.csv"
if(Test-Path $latestFilename) {
    Remove-Item $latestFilename -Force
}

Copy-Item -Path $filename_detailRpt -Destination $latestFilename