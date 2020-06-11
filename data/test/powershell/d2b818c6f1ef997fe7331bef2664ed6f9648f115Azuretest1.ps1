<#
    Login as rexdekoning@outlook.com
    AzureAD account doesn't work
#>
Login-AzureRmAccount
Get-AzureRmSubscription

Get-AzureRmResourceGroup

Get-AzureRmNetworkSecurityGroup
<#
https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-nsg-arm-ps
https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/swarm-mode
https://www.simple-talk.com/sysadmin/virtualization/working-windows-containers-docker-basics/
https://www.sep.com/sep-blog/2017/02/27/nginx-reverse-proxy-to-asp-net-core-separate-docker-containers/
https://hub.docker.com/r/microsoft/sample-nginx/
https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/manage-windows-dockerfile

#todo
https://www.sep.com/sep-blog/2017/02/24/nginx-reverse-proxy-to-asp-net-core-same-container/
https://www.sep.com/sep-blog/2017/02/27/nginx-reverse-proxy-to-asp-net-core-separate-docker-containers/
https://stefanscherer.github.io/run-linux-and-windows-containers-on-windows-10/

https://github.com/olljanat/nginx-nanoserver
docker build -t nginx-nanoserver .
docker run -d --name nginx -p 80:80 nginx-nanoserver
docker run -d --name nano -p 81:80 nanoserver/iis
Enter-PSSession -ContainerId (Get-Container -Name nginx).ID -RunAsAdministrator
test
#> 