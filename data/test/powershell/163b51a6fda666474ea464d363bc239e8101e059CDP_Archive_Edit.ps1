<#
Name: CDP_Archives_Edit.ps1
Date 1.19.17
Programmer: Erik Flores

Purpose: To add the archive links to CDP Manage configuration file. Script will read file and look for "CDPManage.WebService" and add the databases links. The file will be truncated if a match is found. 
#>

Clear-Host
$filename = "C:\Program Files (x86)\Carswell Data Products\CDP e-Sig Plus\Manage\CDPManage.config"

(Get-Content $fileName) |
    ForEach-Object {
        $_ # send the current line to output
        if ($_ -Match "CDPManage.WebService"){
            '      <item name="HR" value="http://cnt-cdp/CDPManageWebService_HR/CDPManageWebService.asmx" />'
            '      <item name="&lt;=2005" value="http://cnt-cdp/CDPManageWebService05nB4/CDPManageWebservice.asmx" />'
            '      <item name="2006" value="http://cnt-cdp/CDPManageWebService2006/CDPManageWebservice.asmx" />'
            '      <item name="2007" value="http://cnt-cdp/CDPManageWebService2007/CDPManageWebService.asmx" />'
            '      <item name="2008" value="http://cnt-cdp/CDPManageWebService2008/CDPManageWebService.asmx" />'
            '      <item name="2009-2015" value="http://cnt-cdp/CDPManageWebService2010_2015/CDPManageWebService.asmx" />'
            '    </add>'
            '  </appSettings>'
            '</configuration>'
            Exit    
     }
  
    } | Set-Content ( $fileName)
    

  