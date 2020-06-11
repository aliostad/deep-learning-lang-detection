Add-Type -Path 'c:\Scripts\Modules\ManagedEsent\Esent.Interop.dll'
if ( [string]::IsNullOrEmpty([psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::get["api"]) )
{
    [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::add("api", "Microsoft.Isam.Esent.Interop.Api")
}

$instance = New-Object Microsoft.Isam.Esent.Interop.JET_INSTANCE
$sesid = New-Object Microsoft.Isam.Esent.Interop.JET_SESID
$dbid = New-Object Microsoft.Isam.Esent.Interop.JET_DBID
$tableid = New-Object Microsoft.Isam.Esent.Interop.JET_TABLEID

$columnDef = New-Object Microsoft.Isam.Esent.Interop.JET_COLUMNDEF
$columnId = New-Object Microsoft.Isam.Esent.Interop.JET_COLUMNID

[api]::JetCreateInstance([ref]$instance, "test")

[api]::JetSetSystemParameter($instance, [Microsoft.Isam.Esent.Interop.JET_SESID]::Nil, [Microsoft.Isam.Esent.Interop.JET_param]::CircularLog, 1, $null)
[api]::JetInit([ref] $instance)
[api]::JetBeginSession($instance, [ref]$sesid, $null, $null)

#[Microsoft.Isam.Esent.Interop.JET_CP]::Unicode

[api]::JetCreateDatabase($sesid, "C:\temp\esentdb\data.db", $null, [ref]$dbid, [Microsoft.Isam.Esent.Interop.CreateDatabaseGrbit]::OverwriteExisting);

[api]::JetCloseTable($sesid, $tableid)
[api]::JetEndSession($sesid, [Microsoft.Isam.Esent.Interop.EndSessionGrbit]::None)
[api]::JetTerm($instance)