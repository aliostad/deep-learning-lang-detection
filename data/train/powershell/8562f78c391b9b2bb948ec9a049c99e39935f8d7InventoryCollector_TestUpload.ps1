
Function Upload-File($uri,$filepath)  
 {  
   $wc = New-Object System.Net.WebClient  
   try  
   {  
     $wc.uploadFile($uri,$filepath)
     #LogEvent 1 "The Inventory XML file was uploaded successfully"
     "The Inventory XML file was uploaded successfully"
   }  
   catch [System.Net.WebException]  
   {  
    #LogEvent 0 "An error occured while trying to upload the inventory file: System.Net.WebException"
    "An error occured while trying to upload the inventory file: System.Net.WebException"
   }   
   finally  
   {    
     $wc.Dispose()  
   }  
 }  

 ###### Save information in local XML file ######
#$name = Get-WmiObject Win32_ComputerSystem | select dnshostname,Domain
#$sysfqdn = $name.dnshostname + "." + $name.Domain
#$dt = '{0:yyyyMMdd-HHmm}' -f (Get-Date)
#$v = "$sysfqdn-$dt.xml" 
$v = "IND065GWA049.caas.local-20141012-1109.xml"
$filepath = "U:\scripts\input\$v"
$filenameEncoded = ($v).Replace(".","%2E")
$uri = "http://172.31.63.29/ServersInventoryAPI1/api/FileUpload?filename=$filenameEncoded&uploadtype=inventory"
#$uri = "http://172.31.63.28/babychefAPI/api/serverFileUpload?filename=$filenameEncoded&uploadtype=inventory"

 
    # Upload inventory file using WEB API call   
    Upload-File $uri $filepath