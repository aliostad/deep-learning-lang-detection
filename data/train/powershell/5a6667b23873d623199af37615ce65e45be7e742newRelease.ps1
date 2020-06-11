#New Release PowerShell Script
echo "Doing a Release for Simutrans"
echo "Please, edit the chocolateyInstall.ps1 URLs and the NUSPEC files"
pause
echo "Let's do it"
rm *.nupkg
#choco update all
#choco install nuget.commandline
#nuget SetApiKey [API_KEY_HERE] -source http://chocolatey.org/
#choco install PACKAGE -source '%cd%' -force
choco pack simutrans.nuspec
choco pack pak64/simutrans-pak64.nuspec
choco pack pak128/simutrans-pak128.nuspec
choco push simutrans.*.nupkg
choco push simutrans-pak64*.nupkg
choco push simutrans-pak128*.nupkg