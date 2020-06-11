
#Write-Host $PSScriptRoot
#Read-Host "please proceed"

#CHANGE THESE THREE VARIABLES
$User = "felix.freye@stebra.se"
$TenantURL = "https://stebra.sharepoint.com"
$Site = "https://stebra.sharepoint.com/sites/SD1"

#Add references to SharePoint client assemblies and authenticate to Office 365 site – required for CSOM
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Taxonomy.dll"
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString

#Bind to MMS
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($Site)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)
$Context.Credentials = $Creds
$MMS = [Microsoft.SharePoint.Client.Taxonomy.TaxonomySession]::GetTaxonomySession($Context)
$Context.Load($MMS)
$Context.ExecuteQuery()

#Retrieve Term Stores
$TermStores = $MMS.TermStores
$Context.Load($TermStores)
$Context.ExecuteQuery()

#Bind to Term Store
$TermStore = $TermStores[0]
$Context.Load($TermStore)
$Context.ExecuteQuery()

#Retrieve Groups
$Groups = $TermStore.Groups
$Context.Load($Groups)
$Context.ExecuteQuery()

#Retrieve TermSets in each group
Foreach ($Group in $Groups)
    {
    $Context.Load($Group)
    $Context.ExecuteQuery()

    #Check if this is right group
    if($Group.Name -eq "Webbplatssamling - stebra.sharepoint.com-sites-SD1")
    {  
        #Write-Host "Group Name:" $Group.Name -ForegroundColor Green
        $TermSets = $Group.TermSets
        $Context.Load($TermSets)
        $Context.ExecuteQuery()

        Foreach ($TermSet in $TermSets)
        {

            #check if it is the rigth termSet
            if($TermSet.Name -eq "Project")
            {

                $JSON = 'var terms = {'
                
                $JSON = $JSON + '"'+$TermSet.Name+'":{'
                #Write-Host "      Term Set Name:"\$TermSet.Name -ForegroundColor Yellow
                #Write-Host "        Terms:" -ForegroundColor DarkCyan

                

                $Terms = $TermSet.Terms
                $Context.Load($Terms)
                $Context.ExecuteQuery()
                $termNumber = 0
                Foreach ($Term in $Terms)
                {
                    $termNumber += 1

                    #Write-Host $Term.Name
                    $JSON += '"'+$Term.Name+'":{'



                    if ($Term.CustomProperties.Count -gt 0)
                    {
                        $JSON+= $Term.CustomProperties.Keys +':'+ $Term.CustomProperties.Values
                        #Write-Host "   "$Term.CustomProperties.Keys : $Term.CustomProperties.Values
                        #Write-Host "   "$Term.CustomProperties.Values
                    }

                    $JSON+='}'

                    if ($termNumber -ne $Terms.Count)
                    {
                        $JSON += ','
                    }
                    #Write-Host "            " $Term.Name -ForegroundColor White
                    #Write-Host "            " $Term.CustomProperties -ForegroundColor White
                    #Write-Host $JSON.ToString()
                }
                $JSON = $JSON + "}}; export default terms;"
                Write-Host " "
                Write-Host " "
                Write-Host "terms.txt:"
                Write-Host $JSON -ForegroundColor Yellow

                $path = $PSScriptRoot+"\terms.txt" 

                Write-Host $path -ForegroundColor Magenta

                

                #$PSScriptRoot
                $JSON | Out-File $path
                Write-Host "File created" -ForegroundColor Green
            }
        }
    }
}

    