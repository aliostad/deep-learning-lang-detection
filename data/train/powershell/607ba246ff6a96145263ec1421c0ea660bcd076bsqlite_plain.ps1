# http://www.sqlite.org/download.html
# 
# 
# System.Data.SQLite.dll 

#  many moving parts 
#    <bin>\App.exe (optional, managed-only application executable assembly)
#    <bin>\App.dll (optional, managed-only application library assembly)
#    <bin>\System.Data.SQLite.dll (required, managed-only core assembly)
#    <bin>\System.Data.SQLite.Linq.dll (optional, managed-only LINQ assembly)
#    <bin>\System.Data.SQLite.EF6.dll (optional, managed-only EF6 assembly)
#    <bin>\x86\SQLite.Interop.dll (required, x86 native interop assembly)
#    <bin>\x64\SQLite.Interop.dll (required, x64 native interop assembly)
# 
# http://system.data.sqlite.org/downloads/1.0.94.0/sqlite-netFx40-setup-bundle-x86-2010-1.0.94.0.exe
# do not use default
# C:\Program Files\System.Data.SQLite\2010

# custom install :
# core manage 
# core native
# test

# clear checkboxes for everything else
# clear generating native image cache images

# you will end up having just one monolythic DLL: System.Data.SQLite.dll

# try to load into Powershell:

	
# the SQLite3 cannot be instantiated.

$o = new-object -type 'System.Data.SQLite.generic'

new-object : Cannot find type [System.Data.SQLite.generic]: make sure theassembly containing this type is loaded.
PS C:\Users\sergueik\code\powershell> $conn = New-Object System.Data.SQLite.SQLiteConnection

$conn.ConnectionString = "Data Source=C:\temp\PSData.db"
$conn.Open()
$command = $conn.CreateCommand()
$command.CommandText = "select DATETIME('NOW') as now, 'Bar' as Foo"
$adapter = New-Object -TypeName 'System.Data.SQLite.SQLiteDataAdapter' $command
$dataset = New-Object -TypeName 'System.Data.DataSet'
[void]$adapter.Fill($dataset)

# to do it right follow the link
http://poshcode.org/2879
$SQLite = New-Module {
 
        Function querySQLite {
                param([string]$query)
 
                        $datatSet = New-Object System.Data.DataSet
                       
                        ### declare location of db file. ###
                        $database = "$scriptDir\data"
                       
                        $connStr = "Data Source = $database"
                        $conn = New-Object System.Data.SQLite.SQLiteConnection($connStr)
                        $conn.Open()
 
                        $dataAdapter = New-Object System.Data.SQLite.SQLiteDataAdapter($query,$conn)
                        [void]$dataAdapter.Fill($datatSet)
                       
                        $conn.close()
                        return $datatSet.Tables[0].Rows
                       
        }
       
        Function writeSQLite {
                param([string]$query)
               
                        $database = "$scriptDir\data"
                        $connStr = "Data Source = $database"
                        $conn = New-Object System.Data.SQLite.SQLiteConnection($connStr)
                        $conn.Open()
                       
                        $command = $conn.CreateCommand()
                        $command.CommandText = $query
                        $RowsInserted = $command.ExecuteNonQuery()
                        $command.Dispose()
        }
       
        Export-ModuleMember -Variable * -Function *
} -asCustomObject

#  http://stackoverflow.com/questions/4552588/using-sqlite-from-powershell-on-windows-7x64

function Add-SqliteAssembly {
    # determine bitness (32 vs. 64) of current PowerShell session
    # I'm assuming bitness = system architecture here, which won't work on IA64, but who cares
    switch ( [intptr]::Size ) {
        4   { $binarch = 'x86' }
        8   { $binarch = 'x64' }
    }
    $modPath = $MyInvocation.MyCommand.Module.ModuleBase
    $SQLiteBinName = 'System.Data.SQLite.dll'
    $SQLiteBinPath = "$modPath\$binarch\$SQLiteBinName"
    Add-Type -Path $SQLiteBinPath 
}

<# to find the location of the installed .net assembly on the system
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{02E43EC2-6B1C-45B5-9E48-941C3E1B204A}_is1]
"Inno Setup: Setup Version"="5.5.5 (a)"
"Inno Setup: App Path"="c:\\tools\\sqlite3"
"InstallLocation"="c:\\tools\\sqlite3\\"
"Inno Setup: Icon Group"="System.Data.SQLite\\2010"
"Inno Setup: No Icons"=dword:00000001
"Inno Setup: User"="sergueik"
"Inno Setup: Setup Type"="custom"
"Inno Setup: Selected Components"="application,application\\core,application\\core\\msil,application\\core\\x86,application\\test"
"Inno Setup: Deselected Components"="application\\linq,application\\ef6,application\\designer,application\\designer\\installer,application\\symbols,application\\documentation"
"Inno Setup: Selected Tasks"="ngen"
"Inno Setup: Deselected Tasks"="gac"
"Inno Setup: Language"="default"
"DisplayName"="System.Data.SQLite v1.0.94.0 (Release)"
"UninstallString"="\"c:\\tools\\sqlite3\\uninstall\\unins000.exe\""
"QuietUninstallString"="\"c:\\tools\\sqlite3\\uninstall\\unins000.exe\" /SILENT"
"DisplayVersion"="1.0.94.0"
"Publisher"="System.Data.SQLite Team"
"URLInfoAbout"="http://system.data.sqlite.org/"
"HelpLink"="http://system.data.sqlite.org/"
"URLUpdateInfo"="http://system.data.sqlite.org/"
"Readme"="c:\\tools\\sqlite3\\readme.htm"
"Comments"="The ADO.NET adapter for the SQLite database engine."
"NoModify"=dword:00000001
"NoRepair"=dword:00000001
"InstallDate"="20141209"
"MajorVersion"=dword:00000001
"MinorVersion"=dword:00000000
"EstimatedSize"=dword:00000f60

#>
