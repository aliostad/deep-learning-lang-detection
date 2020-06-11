Push-Location $psScriptRoot

function loadPrerequisiteAssembly {
    param (
        [string] $name,
        [IO.FileInfo] $file
    )
    
    try { 
        $a = [Reflection.Assembly]::Load($name)
    }
    catch [IO.FileNotFoundException] {
	    if($a -eq $null) {
		$a = [Reflection.Assembly]::LoadFrom($file.FullName)
	    }
    }
}

loadPrerequisiteAssembly "PowerCollections" (Get-Item ./bin/PowerCollections.dll)
loadPrerequisiteAssembly "RdfCore" (Get-Item ./bin/RdfCore.dll)

gci -Path ./Rdf -Filter *.ps1 | %{ . $_.FullName }
gci -Path ./Sparql -Filter *.ps1 | %{ . $_.FullName }
gci -Path ./Model -Filter *.ps1 | %{ . $_.FullName }

Pop-Location

Export-ModuleMember -Function @('New-DataSource', 'ConvertTo-RdfValue', 'New-RdfLiteral', 'New-RdfUri', 'Restore-RdfObject', 'Save-DataSource', 'New-Table', 'New-TableRow', 'Save-Table', 'Restore-Table',  'New-Statement', 'New-ClientModel')
