Param(  
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]  
    [string] $CredentialObjectName
)  
	
function Connect-ExchangeOnline {
    param (
        $CredentialObject
    )
    #Clean up existing PowerShell Sessions
    Get-PSSession | Remove-PSSession
    #Connect to Exchange Online
	
	try
	{
		$session = New-PSSession –ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $CredentialObject -Authentication Basic -AllowRedirection
	}
	catch
	{
		Write-Error "An error occurred when attempting to create the Exchange Online session."
		Write-Error $_.Exception
	}
    
	if ($session -ne $null)
	{
	
		try
		{
	    	Import-PSSession -Session $session -DisableNameChecking:$true -AllowClobber:$true | Out-Null
			Write-Output "Connected to Exchange Online."
		}
		catch{
			Write-Error "An error occurred attempting to connect to Exchange Online"
	        Write-Error $_.Exception
			
			if($session -ne $null)
			{
				Remove-PSSession $session
			}
			exit	
		}
		
	    return $session
		
	}
	else
	{
		Write-Error "Session not created."
		return $null
	}
	
}
   
$CredentialObject = Get-AutomationPSCredential -Name $CredentialObjectName

$session = Connect-ExchangeOnline -CredentialObject $CredentialObject

if($session -eq $null) { exit }
 
#Collect Message Tracking Logs (These are broken into "pages" in Office 365 so we need to collect them all with a loop)  
$messages = @()
$dtNow = (Get-Date)
$dtStart = (Get-Date).AddHours(-1)
$Page = 1  
do  
{  
    Write-Output "Collecting Message Tracking - Page $Page..."  
    $CurrMessages = Get-MessageTrace -PageSize 5000 -Page $Page -StartDate ([DateTime]::New($dtStart.Year, $dtStart.Month, $dtStart.Day, $dtStart.Hour,0,0)) -EndDate ([DateTime]::New($dtNow.Year, $dtNow.Month, $dtNow.Day, $dtNow.Hour,0,0)) | Select Received,SenderAddress,RecipientAddress 
    $Page++  
    $messages += $CurrMessages  
}  
until ($CurrMessages -eq $null)  

$results=@()

foreach($message in $messages)
{
    if (((-not($message.senderaddress -like "*silversands.co.uk")) -and (-not($message.senderaddress -like "*silversands.onmicrosoft.com")) -and (-not($message.senderaddress -like "*silversands.mail.onmicrosoft.com"))) -xor ((-not($message.recipientaddress -like "*silversands.co.uk")) -and (-not($message.recipientaddress -like "*silversands.onmicrosoft.com"))-and (-not($message.recipientaddress -like "*silversands.mail.onmicrosoft.com"))))
    {
		# Has external party
		if((-not($message.senderaddress -like "*silversands.co.uk")) -and (-not($message.senderaddress -like "*silversands.onmicrosoft.com")) -and (-not($message.senderaddress -like "*silversands.mail.onmicrosoft.com")))
		{
			$strDirection = "Inbound"
			$strExternalDomain = $message.senderaddress.split('@')[1]
		}
		else
		{
			$strDirection = "Outbound"
			$strExternalDomain = $message.recipientaddress.split('@')[1]
		}
		$results+=@{"ReceivedDateTime"=(Get-Date -date $message.Received -format "yyyy-MM-ddTHH:mm:ssZ");"SenderAddress"=$message.SenderAddress;"RecipientAddress"=$message.RecipientAddress;"Direction"=$strDirection;"ExternalDomain" = $strExternalDomain}
		
	}
}

$connectionName = "OMSAutoConnect"
try
{
	# Get the connection "AzureRunAsConnection "
	$servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

	"Logging in to Azure..."
	Add-AzureRmAccount `
		-ServicePrincipal `
		-TenantId $servicePrincipalConnection.TenantId `
		-ApplicationId $servicePrincipalConnection.ApplicationId `
		-CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
	if (!$servicePrincipalConnection)
	{
		$ErrorMessage = "Connection $connectionName not found."
		throw $ErrorMessage
	} else{
		Write-Error -Message $_.Exception
		throw $_.Exception
	}
}

"Logged in."

Start-AzureRmAutomationRunbook -Name "WfRecipientStatsToIOT" -Parameters @{"messages"=$results}  -AutomationAccountName "OMSAutomation" -ResourceGroupName "SSOMS"