# ----------------------------------------
# This script is useful if you have a web console for clients' certificate request and your company has got local support specialists who manage certificate issuing process.
# Script has to be attached to "issue new certificate" event ("Certificate issued", Event ID 4887 in Security event log), sends email to local specialists, and a requester.
# ----------------------------------------

# Temporary CSV file to store certificate details
[string]$TempCertListFile = "C:\temp\certlist_issued.txt"

# Export all issued certificates to CSV ("Disposition=20" is for all issued certs)
& certutil -view -restrict "Disposition==20" -out "Request ID, Request Submission Date, Request Common Name, Requester Name, Request Email Address, Certificate Effective Date" csv > $TempCertListFile
    
# Export all certs from CSV to an array
$CertObjects = Import-Csv $TempCertListFile

# Add a [datetime] property to every array object to sort em
$CertObjects | ForEach {
    # Null the temporary variables
    [string]$String = ""
    [datetime]$DateTime = "01.01.1000 00:00"

    [string]$String = $_."Certificate Effective Date"
    # Convert a string to [datetime] type
    [datetime]$DateTime=[datetime]::ParseExact($String, "dd.MM.yyyy HH:mm", $null)

    # Add a [datetime] property to current object
    Add-Member -InputObject $_ –MemberType NoteProperty –Name IssuedDate –Value $DateTime
    }

# Sort certs by issue date, get the last one
$LastIssuedCert = $CertObjects | sort IssuedDate | Select-Object -Last 1

# Email data from cert
[string]$Email = $LastIssuedCert."Request Email Address"
[string]$RequestDate = ($LastIssuedCert."Request Submission Date").SubString(0,10)
[string]$RequestName = $LastIssuedCert."Requester Name"
[string]$RequestCN = $LastIssuedCert."Request Common Name"

# Send an email to local specialists and the requester
# Send via mail server
$SmtpServer = "mail.company.com"
# .NET object MailMessage
$Msg = New-Object Net.Mail.MailMessage
# .NET object SMTP
$Smtp = New-Object Net.Mail.SmtpClient($SmtpServer)
# Email structure
$Msg.From = "ca@company.com"
$Msg.ReplyTo = "ca-admins@company.com"
$Msg.To.Add($Email)
# A hidden copy for local support specialists
$Msg.CC.Add("ca-admins@company.com")
$Msg.Subject = "Your Company client certificate has been issued"
$Msg.Body = "Dear user,`r`n`r`nYou have requested a client certificate at COMPANY on $RequestDate for $RequestCN.`r`nYour request has been approved, to get your certificate please follow the link https://ca.company.com/certsrv/ and download it.`r`nShould you have any questions, please contact us at application-admins@company.com"
$Msg.SubjectEncoding = [System.Text.Encoding]::UTF8
$Msg.BodyEncoding = [System.Text.Encoding]::UTF8
# Send email
$Smtp.Send($Msg)