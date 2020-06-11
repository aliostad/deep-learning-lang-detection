$moveTo = "ndtest.domain.local/Old Accounts"
$olderThan = 60

function loadQADsnapin()
{
    if ((Get-PSSnapin -name quest.activeroles.admanagement -ErrorAction SilentlyContinue) -eq $null)
    {
        Add-PSSnapin quest.activeroles.admanagement
    }
}

function findUsers(){
    Get-QADuser -IncludedProperties edsvaDeprovisionReportXML,edsvaDeprovisionStatus -Proxy | ForEach-Object {
        if (($_.edsvaDeprovisionReportXML) -and ($_.edsvaDeprovisionStatus = 2)){
            [xml]$userXML = $_.edsvaDeprovisionReportXML
            $userExpiry = Get-Date($userXML.report.table.row.sections.section[1].list.ChildNodes[8].t.date)
            $timeSpan = New-TimeSpan $userExpiry (Get-Date)

            if (($timeSpan.days -gt $olderThan) -and ($_.ParentContainer -ne $moveTo)){
                moveUser $_.LogonName
            }
        }
    }
}

function moveUser($username){
    Move-QADObject -Identity $username -NewParentContainer $moveTo
}

loadQADsnapin
findUsers