#
# Script to perform Extract-Transform-load steps around resource planning and reporting
#

param ([ValidateSet("Planned","Actual")]
        [string]$Action="Planned",
       [ValidateSet("Current","Next","Last",
                    "January","February","March",
                    "April","May","June",
                    "July","August","September",
                    "October","November","December")]
        [string]$Month="Next",
        $Year)

$monthId = .\Get-MonthId.ps1 -Month $Month -Year $Year

Write-Host $monthId

.\Report-MonthPlan.ps1 -CurrentMonth $false -monthId $monthId

.\Analyse-MonthPlan.ps1 -MonthlyReport .\MonthlyPlan-${monthId}.csv -ReportType $Action
