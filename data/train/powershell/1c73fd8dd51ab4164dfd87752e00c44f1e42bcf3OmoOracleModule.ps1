$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\DatabaseModule.ps1" 
. "$here\OracleModule.ps1" 

#http://www.oracle.com/technetwork/developer-tools/visual-studio/overview/index.html
#Oracle Management Objects 


function Load-OracleAssemblyesOmo
{
    Load-OracleAssemblyes

    $odtAsmName = "Oracle.Management.Omo, Version=4.112.3.0, Culture=neutral, PublicKeyToken=89b483f429c47342"
    [Reflection.Assembly]::Load($odtAsmName)

}


function New-OracleConnectionOmo ([string] $connectionString)
{
    [string]$oracleConnectionType = 'Oracle.Management.Omo.Connection'
    return new-object -TypeName $oracleConnectionType -ArgumentList $connectionString 
}
