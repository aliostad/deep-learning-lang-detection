#Show the function does not exists
Get-Command `
| Where-Object {$_.CommandType -eq 'Function' -and $_.Name -eq 'Hello-World'} 


#Example of how to create a funciton
function Hello-World ([string]$Name) { 
Write-Host "Hello $Name"
}

#Show the function now exists
Get-Command `
| Where-Object {$_.CommandType -eq 'Function' -and $_.Name -eq 'Hello-World'} `
|Select-Object -ExpandProperty Definition 

#Call Funtion
Hello-World "SQL Saturday 209"
