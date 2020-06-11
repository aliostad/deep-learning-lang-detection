#First, let's review some of the basic operators
#All operators will return a boolean value
1 -eq 2
1 -eq 1

1 -ne 2
1 -ne 1

1 -lt 2
1 -gt 2

#Operators can be combined with -and/-or for multiple conditions
#-and will only return true if all conditions are met
(1 -eq 1) -and (1 -eq 2)

#-or will return true if any condition is met
(1 -eq 1) -or (1 -eq 2)

#We can use these to drive conditional statements
#Note, $true and $false are system variables that represent boolean values
Test-Path C:\PowershellLab
if(Test-Path C:\PowershellLab -eq $false){New-Item -Path C:\PowershellLab}
Test-Path C:\PowershellLab

#These can also be used to manage loops
$start = Get-Date
do{Write-Host -ForegroundColor Yellow 'Waiting...';Start-Sleep -Seconds 1}while(((Get-Date)-$start).Seconds -lt 15)

#Loops can be managed by other checks
#In a for loop, it will first be the initial value, then the condition to check, then what happens on each loop
for($i=0;$i -lt 15;$i++){Write-Host -ForegroundColor Yellow "Waiting $i...";Start-Sleep -Seconds 1}

#Finally, we can loop through arrays and collections with foreach
$names = @('Kirk','Spock','Scotty','McCoy')
foreach($name in $names){Write-Host -ForegroundColor Green $name}

#As a bonus, there's a special cmdlet that works like foreach called ForEach-Object that allows us to
#loop via the pipeline
$names | ForEach-Object {Write-Host -ForegroundColor Green $_}

#Because it's the pipeline, we can further manipulate things
$names| Sort-Object | ForEach-Object {Write-Host -ForegroundColor Green $_}