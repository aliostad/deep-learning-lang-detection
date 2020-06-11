function BuildXML
#supply username and password and HashTable with message objects built with function "CreateMessageObjects".#
#the function will generate a XML object that can be used to submitt messages to PSWinCom SMS Gateway (www.pswin.com)
{
	param
	(
		[string]$UserName = $(Throw 'No username provided'),
		[string]$Password = $(Throw 'No Password provided'),
		[Hashtable]$HTBL_RCV_MSG= $(Throw 'No message provided')

		
	)
	$SMS_XML = New-Object XML
	$XML_Session = $SMS_XML.CreateElement('SESSION')
	$XML_Client = $SMS_XML.CreateElement('CLIENT')
	$XML_Client.set_InnerText($UserName)
	$XML_PW = $SMS_XML.CreateElement('PW')
	$XML_PW.set_InnerText($Password)	
	#MessageList_Block
	$XML_MSGLST = $SMS_XML.CreateElement('MSGLST')
	$ID=1
	foreach ($Message in $HTBL_RCV_MSG.keys)
	{
		
		$XML_MSG = $SMS_XML.CreateElement('MSG')
		$XML_ID = $SMS_XML.CreateElement('ID')
		$XML_ID.set_innerText($ID)
		$XML_Text = $SMS_XML.CreateElement('TEXT')
		$XML_Text.Set_innerText($HTBL_RCV_MSG.item($Message).Message_text)
		$XML_RCV = $SMS_XML.CreateElement('RCV')
		$XML_RCV.Set_InnerText($HTBL_RCV_MSG.item($Message).Receiver)
		if($HTBL_RCV_MSG.item($Message).Sender.length -ne 0)
		{
			$XML_SND = $SMS_XML.CreateElement('SND')
			$XML_SND.Set_InnerText($HTBL_RCV_MSG.item($Message).Sender)
		}
		if($HTBL_RCV_MSG.item($Message).Deliverytime.length -ne 0)
		{
			$XML_DELIVERYTIME = $SMS_XML.CreateElement('DELIVERYTIME')
			$XML_DELIVERYTIME.Set_InnerText($HTBL_RCV_MSG.item($Message).DELIVERYTIME)
		}
		
		if($HTBL_RCV_MSG.item($Message).Deliverytime.length -ne 0)
		{
			$XML_TTL = $SMS_XML.CreateElement('TTL')
			$XML_TTL.Set_InnerText($HTBL_RCV_MSG.item($Message).DELIVERYTIME)
		}

			$XML_MSGLST.AppendChild($XML_MSG)
			$XML_MSG.AppendChild($XML_ID)
			$XML_MSG.AppendChild($XML_TEXT)
			$XML_MSG.AppendChild($XML_RCV)
			if($XML_SND -ne $null)
			{
				$XML_MSG.AppendChild($XML_SND)
			}
			
			if($XML_DELIVERYTIME -ne $null)
			{
				$XML_MSG.AppendChild($XML_DELIVERYTIME)
			}
			
			if($XML_TTL -ne $null)
			{
				$XML_MSG.AppendChild($XML_TTL)
			}

		$ID++
	}
	#/MessageList_Block		
	$SMS_XML.AppendChild($XML_Session)
	$SMS_XML["SESSION"].AppendChild($XML_Client)
	$SMS_XML["SESSION"].AppendChild($XML_PW)
	$SMS_XML["SESSION"].AppendChild($XML_MSGLST)
	Write-Host $SMS_XML.OuterXml.ToString()
	
	return $SMS_XML
	
	
}

Function SendSMS 
#Function that submitts the SMS to PSWinCom Gateway (www.pswin.com). 
#XMLBLOCK should be a String containing XML code. not an XML object.
{
	Param
	(
		[string]$XMLBLOCK,
		[Boolean]$Debug,
		[STRING]$Url = 'https://secure.pswin.com/XMLHttpWrapper/process.aspx'
		#[STRING]$Url = 'https://gw2-fro.pswin.com:8443'
	)
	
	If($Debug -eq 'TRUE')
	{
		write-host $XMLBLOCK
	}
	
	$Http = New-Object System.Net.WebClient
	$HttpResponse = $Http.UploadString($Url,'POST',$XMLBLOCK)
	return $HttpResponse

}
function CreateMessageObjects
#builds message objects that can be stored in a hashtable and then sent to the buildXML function.

{
	Param
	(
		[String]$Receiver = $(Throw 'You must provide a Receiver'),
		[String]$Message_text= $(Throw 'You must provide a Message'),
		[String]$Tarriff,
		[String]$MessageClass,
		[String]$Sender,
		[String]$TTL,
		[String]$deliverytime
				
	)
	$Message = New-Object PSObject
	Add-Member -Input $Message NoteProperty 'Receiver' $Receiver
	Add-Member -Input $Message NoteProperty 'Message_text' $Message_text
	Add-Member -Input $Message NoteProperty 'Tarriff' $Tarriff #not yet implemented
	Add-Member -Input $Message NoteProperty 'MessageClass' $MessageClass #not yet implemented
	Add-Member -Input $Message NoteProperty 'Sender' $Sender #Number or Name of sender.
	Add-Member -Input $Message NoteProperty 'TTL' $TTL #time to live in Minutes
	Add-Member -Input $Message NoteProperty 'deliverytime' $deliverytime #YYYYMMDDHHmm
	
	Return $Message
}
