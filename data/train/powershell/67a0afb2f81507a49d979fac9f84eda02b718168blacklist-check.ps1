
#####################
# Blacklist Checker #
#   hydramail.net   #
#####################


#to add mroe blacklists to check against, edit the file: blacklists.txt
#to add more servers to check, edit the file: servers.txt


#set the credentials for the email account you will be using to send the email
$secpasswd = ConvertTo-SecureString "PASSWORD" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("blacklist@hydramail.net", $secpasswd)

#define the file that will contain the blacklists to check against, add them to an array
$blacklist_list = Get-Content C:\Scripts\blacklist\blacklist.txt

#define the file that will contain the servers to check, add them to an array
$server_list = Get-Content C:\Scripts\blacklist\servers.txt



#define the output array
$output = @()

#add some formatting to the output array
$output +=  '<div style="font-family: Segoe UI;font-size:x-small;">'

#add the title to the output array
$output += '<b>Mail Server is on the following blacklists</b><br><br><br>'


#loop through each blacklist
foreach ($bl in $blacklist_list)
{

    #for each blacklist checked, loop through each server
    foreach ($cas_server in $server_list){

        #split the IP into individuakl octets       
        $ip_array = $cas_server -split '\.'
        #reverse the octets
        [array]::Reverse($ip_array)
        #convert back to a string
        $reverse_ip = $ip_array -join "."

        #combine the reverse ip and blacklist strings
        $bl_check = $reverse_ip + '.' + $bl

        #check if there is a TXT for the above string
        Resolve-DnsName -Name $bl_check -Type TXT -ErrorAction SilentlyContinue | foreach-object {

        #add the items in the answer to a variable
        $blacklisted = $_.Name
        $details = $_.Strings | Out-String

        #add some html to make it pretty
        $cas_server1 = $cas_server + '<br>'
        $bl1 = $bl + '<br>'
        $blacklisted1 = $blacklisted + '<br>'
        $details1 = $details + '<br>'

        #assign the variables to an object, easier to manage
        $object = New-Object -TypeName PSObject
        $object | Add-Member -Name 'IP' -MemberType Noteproperty -Value $cas_server1
        $object | Add-Member -Name 'Blacklist' -MemberType Noteproperty -Value $bl1
        $object | Add-Member -Name 'Query' -MemberType Noteproperty -Value $blacklisted1
        
        #don't need to add the detaisl section of a TXT record if it's an SPF record
        #only keep it if it's an answer for the blacklist check
        if ($details -like '*v=spf1*') {}
                                 else{$object | Add-Member -Name 'Details' -MemberType Noteproperty -Value $details1}
      
        #add the object to the output array
        $output += $object
        #add a html break to add a new line after each item
        $output += '<br>'

        }
    }

}
#add a html break to add a new line after each item
$output += '</div>'

#assign the output array in list format to the body
$body = $output | fl | Out-String




#################
# send an email #
#################

$send_mail = send-mailmessage -from "blacklist@hydramail.net" -to "andrew@hydramail.net" -subject ("Blacklist Monitoring") -body $body -BodyAsHtml -smtpServer cas-01.hydramail.net -Credential $mycreds

#if the blacklist DNS query returns any data, notify me
if ($object){$send_mail}
