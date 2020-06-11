
function Load-Sln ($file){
	Write-Host "Loading $file"
	start $file.FullName
}

function Present-Options($file_list){
	Write-Host "`nPick a solution to load...`n"
	$idx = 0
	$file_list | ForEach-Object{
		$idx++
		Write-Host "`t$idx`: $_"
	}
}

function Sln(){
	$files = @(Get-ChildItem -Recurse -Filter *.sln)
	if ($files.Length -eq 0){
		Write-Host "No solutions found in this directory. Bye"
		return
	} elseif ($files.Length -eq 1){
		Load-Sln $files[0]
	} else {
		Present-Options $files
		
		do{
			$input = Read-Host "Enter a number, or 'q' to cancel: "
			$loaded = $false
			if ($input -ne "q"){
				$index = ([int]$input) - 1
				if ($index -ge $files.Length){
					Write-Host "Index out of range. Try again" -ForegroundColor Red
				} else {
					$loaded = $true
					Load-Sln $files[$index]
				}
			}			
		} until (($input -eq "q") -or ($loaded -eq $true))
	}
}

Export-ModuleMember -Function @('Sln')

