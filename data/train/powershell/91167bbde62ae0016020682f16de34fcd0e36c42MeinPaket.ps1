#Wait for load the page
function WaitForLoad ($ie)
{
	do {sleep -Seconds 1}
	while ($ie.Busy)
}
function HtmlAnalysis($ie,$ProduktUrl){
	$ie.Navigate($ProduktUrl)
	WaitForLoad $ie
	$resultsDiv = $ie.Document.getElementsByTagName("div")
	foreach($usr_div in $resultsDiv){
		if ($usr_div.className -eq "jspPane"){
			$UsrTableDivs = $usr_div.getElementsByTagName("div")
			foreach($UsRTableDiv in $UsrTableDivs){
				if ($UsRTableDiv.className -eq "td cel1"){
					Write-Host $UsRTableDiv.className $UsRTableDiv.innerText
				}elseif($UsRTableDiv.className -eq "td cel2"){
					Write-Host $UsRTableDiv.className ' - ' $UsRTableDiv.Title
				}else{
					Write-Host $UsRTableDiv.className
				}
			}
		}
	}
}

cls
# Loginname
# $username_or_email = “mja@warensortiment.de”;
# Passwort SecureString
$encrypted = Import-Clixml 'C:\Users\Falk Espenhahn\Documents\MeinePakete.xml'            
$key = (2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43,6,6,6,6,6,6,31,33,60,23)            
$csp = New-Object System.Security.Cryptography.CspParameters
$csp.KeyContainerName = "SuperSecretProcessOnMachine"
$csp.Flags = $csp.Flags -bor [System.Security.Cryptography.CspProviderFlags]::UseMachineKeyStore
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider -ArgumentList 5120,$csp
$rsa.PersistKeyInCsp = $true 
$password = [char[]]$rsa.Decrypt($encrypted.MeinPaket.PW, $true) -join "" |ConvertTo-SecureString -Key $key
$username_or_email = [char[]]$rsa.Decrypt($encrypted.MeinPaket.BN, $true) -join "" |ConvertTo-SecureString -Key $key
#URL's
#Produkte -> https://www.meinpaket.de/de/menu/dealer/myaccount/productmanagement
# CSV -> https://www.meinpaket.de/de/dealer/page/myaccount/productmanagement/showProductDownloadDlg.html
# DownloadDlgf schließen -> https://www.meinpaket.de/de/menu/dealer/myaccount/productmanagement/productsoverview
$url = “https://www.meinpaket.de/de/menu/dealer/home”;
$ProduktUrl = "https://www.meinpaket.de/de/menu/dealer/myaccount/productmanagement";


# Create an ie com object
$ie = New-Object -com internetexplorer.application;
#$ie.visible = $true;
$ie.navigate($url);
# Wait for the page to load
WaitForLoad ($ie)

# Login to Facebook
#Write-Host -ForegroundColor Green “Attempting to login to Facebook.”;
# Add login details
$ie.Document.getElementById(“j_username”).value = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($username_or_email)); ;
$ie.Document.getElementById(“j_password”).value = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)); ;
# Click the submit button
$go = $ie.Document.getElementsByTagName("button") | Where-Object {$_.ClassName -eq "e-button"};
$go.Click();
# Wait for the page to load
WaitForLoad ($ie)
HtmlAnalysis $ie $ProduktUrl
<#
$ie.Navigate("https://www.meinpaket.de/de/dealer/page/myaccount/productmanagement/showProductDownloadDlg.html");
WaitForLoad ($ie)

$rdb_product_csv = $ie.Document.getElementById("basPrd")
$rdb_product_csv.setActive()
$rdb_product_csv.click()
$go = $ie.Document.getElementsByTagName("button") | Where-Object {$_.ClassName -eq "lnkBtnLrg"};
$go.Click();
WaitForLoad ($ie)
#>
$ie.Navigate("https://www.meinpaket.de/de/j_spring_security_logout");
$ie.Quit();
