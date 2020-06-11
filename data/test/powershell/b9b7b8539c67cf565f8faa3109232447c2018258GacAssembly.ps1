Param($GacFolder, $ScriptsFolder)


$dlls = [System.IO.Directory]::GetFiles($GacFolder,"*.dll",[System.IO.SearchOption]::AllDirectories)
$dlls_to_install = @()

foreach ($dll_file in $dlls)
{
	$dll_name = [System.IO.Path]::GetFullPath( $dll_file )

	$ErrorActionPreference = "continue"
         
        if ( $null -eq ([AppDomain]::CurrentDomain.GetAssemblies() |? { $_.FullName -eq "System.EnterpriseServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" }) ) {
             [System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a") | Out-Null
         }
         $publish = New-Object System.EnterpriseServices.Internal.Publish
	 $assembly = $dll_name
            
        
        if ( -not (Test-Path $assembly -type Leaf) ) {
            throw "The assembly '$assembly' does not exist."		
        }
        
       if ( [System.Reflection.Assembly]::LoadFile( $assembly ).GetName().GetPublicKey().Length -eq 0 ) {
            throw "The assembly '$assembly' must be strongly signed."
        }
        
	$publish.GacInstall( $assembly )
        
	echo "Assembly: $dll_name into GAC installed into GAC"
}


 