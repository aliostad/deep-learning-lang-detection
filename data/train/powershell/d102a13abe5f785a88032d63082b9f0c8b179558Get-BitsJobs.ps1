& D:\BamApps\Scripts\PowerShell\InitializeSQLProvider.ps1

function loadDb ($env, $file) 
{
    [xml]$xml = Get-Content $file
    foreach( $job in $xml.configuration.StartupJobs.Job)
    {
        if ($job -ne $null)
        {
            $jobName = $job.Spec.Replace(".xml","")
            write-host ("Job={0}" -f $jobName)    
            invoke-sqlcmd -ServerInstance ag2-rp1 -Database Dashboard -Query "Insert tbl_SLA_BitsJobs values ('$env','$jobName')"
        }
    }
}

invoke-sqlcmd -ServerInstance ag2-rp1 -Database Dashboard -Query "truncate table tbl_SLA_BitsJobs"

$file1 = "\\ag2-rp1\BamApps\PROD1\BITS\bin\BitsShell.exe.config"
$file2 = "\\ag2-rp1\BamApps\PROD1A\BITS\bin\BitsShell.exe.config"
$file3 = "\\ag2-rp1\BamApps\PROD1B\BITS\bin\BitsShell.exe.config"
$file4 = "\\ag2-rp1\BamApps\PROD2\BITS\bin\BitsShell.exe.config"
$file5 = "\\ag2-rp1\BamApps\PROD-USER\BITS\bin\BitsShell.exe.config"

loadDb -env "PROD1" -file $file1
loadDb -env "PROD1A" -file $file2
loadDb -env "PROD1B" -file $file3
loadDb -env "PROD2" -file $file4
loadDb -env "PROD-USER" -file $file5

