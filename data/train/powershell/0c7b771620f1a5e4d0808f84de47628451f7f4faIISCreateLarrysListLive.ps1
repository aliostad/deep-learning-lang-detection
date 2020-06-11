
import-module webadministration

remove-item IIS:\Sites\LarrysList_Live_Api -recurse

remove-item IIS:\AppPools\LarrysListLiveAppPool -recurse
New-Item IIS:\AppPools\LarrysListLiveAppPool
Set-ItemProperty IIS:\AppPools\LarrysListliveAppPool managedRuntimeVersion v4.0


New-Item IIS:\Sites\LarrysList_live_Api -bindings @{protocol="https";bindingInformation=":443:live.api.bookpar.com"} -physicalPath c:\inetpub\wwwroot\LarrysList\LarrysList_Live\LarrysListApi
Set-ItemProperty IIS:\Sites\LarrysList_Live_Api -name applicationPool -value LarrysListLiveAppPool

