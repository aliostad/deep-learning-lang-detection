
import-module webadministration

remove-item IIS:\Sites\LarrysList_Dev_Api -recurse

remove-item IIS:\AppPools\LarrysListDevAppPool -recurse
New-Item IIS:\AppPools\LarrysListDevAppPool
Set-ItemProperty IIS:\AppPools\LarrysListDevAppPool managedRuntimeVersion v4.0


New-Item IIS:\Sites\LarrysList_Dev_Api -bindings @{protocol="https";bindingInformation=":443:dev.api.bookpar.com"} -physicalPath c:\inetpub\wwwroot\LarrysList\LarrysList_Dev\LarrysListApi
Set-ItemProperty IIS:\Sites\LarrysList_Dev_Api -name applicationPool -value LarrysListDevAppPool

remove-item IIS:\Sites\LarrysList_Dev_Reports -recurse

New-Item IIS:\Sites\LarrysList_Dev_Reports -bindings @{protocol="http";bindingInformation=":80:dev.reports.bookpar.com"} -physicalPath c:\inetpub\wwwroot\LarrysList\LarrysList_Dev\LarrysListReports
Set-ItemProperty IIS:\Sites\LarrysList_Dev_Reports -name applicationPool -value LarrysListDevAppPool