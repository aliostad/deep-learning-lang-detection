Function Send-AdminEmail 
{
<#
.SYNOPSIS
Sends email to administrative account.

.DESCRIPTION
Sends email to predefined admin account.

.PARAMETER Sender
The source of the message.

.PARAMETER Subject
The subject of the mail.

.PARAMETER Message
The message to be sent.

.PARAMETER Attachments
Files to be attached to the email.

.PARAMETER ComputerName
Includes the name of the computer sending the message.

.PARAMETER Time
Includes the time at which the message is being sent.

.EXAMPLE
C:\PS> Send-AdminEmail -Sender sender@test.domain -Subject 'Alert' -Message "Hello"

.EXAMPLE
C:\PS> Send-AdminEmail -Sender sender@test.domain -Subject 'Alert' -Message "Hello" -Attachments 'file.txt' -Time
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True,Position=1)]
        [string]$Sender,
        
        [Parameter(Mandatory=$True,Position=2)]
        [string]$Subject,
        
        [Parameter(Mandatory=$True,Position=3)]
        [string]$Message,

        [Parameter(Mandatory=$False,Position=4)]
        [string[]]$Attachments,

        [Parameter(Mandatory=$False)]
        [switch]$ComputerName = $False,

        [Parameter(Mandatory=$False)]
        [switch]$Time = $False
    )
    
    #Variable setup

    $Receiver = 'admin@example.domain'
    $ServerAddress= 'mail.example.domain'
    #$Username = ''
    #$Password = ''
    $Body = ''

    #Message crafting

    If($ComputerName)
    {
        $Body += "Computer: " + [System.Environment]::MachineName + [System.Environment]::NewLine
    }

    If($Time)
    {
        $Body += "Time: " + (Get-Date -Format F | Out-String) + [System.Environment]::NewLine
    }

    $Body += $Message
    
    #Object creation

    $MessageObj = New-Object Net.Mail.MailMessage($Sender,$Receiver,$Subject,$Body)

    If($Attachments)
    {
        ForEach($File in $Attachments)
        {
            $FileObj = New-Object Net.Mail.Attachment($File)
            $MessageObj.Attachments.Add($FileObj)
        }
    }

    $SMTPObj = New-Object Net.Mail.SmtpClient($ServerAddress)
    #$SMTPObj.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)

    #Mail transmission

    Try
    {
        $SMTPObj.Send($MessageObj)
    }
    Catch
    {
        Write-Error "$_"
    }
}
