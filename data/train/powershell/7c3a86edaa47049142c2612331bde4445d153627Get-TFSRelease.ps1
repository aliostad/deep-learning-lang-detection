[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true, Position=0)]
    $ProjectCollection
)

$projectsResult = Invoke-RestMethod "$ProjectCollection/_apis/projects?api-version=1.0" -Method Get -UseDefaultCredentials

$releases = @()

$projectsResult.value | % {

    $project = $_.name

    $url = "$ProjectCollection/$project/_apis/release/releases?api-version=2.2-preview.1"

    $result = Invoke-RestMethod $url -Method Get -UseDefaultCredentials

    if ($result.count -gt 0){
        
        $result.value | % {
            
            $releases += [pscustomobject]@{ 
                Project = $project 
                Name = $_.Name 
                Status = $_.status
                CreatedOn = [datetime]$_.createdOn
                ModifiedOn = [datetime]$_.modifiedOn 
            }
        }
    }
}

$releases | Sort-Object -Property ModifiedOn -Descending | Format-Table -AutoSize