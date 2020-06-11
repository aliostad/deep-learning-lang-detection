# Execution Policy Demo
# Keyboard shortcuts
# tab completion 
# Arrow keys
# (`) for line break
# Ctrl-S to pause output
# F7 for command history
# F8 to search for previous commands
# F9 to run a specific command, 
# Page Up/Down

Get-ExecutionPolicy
Set-ExecutionPolicy RemoteSigned

#-------------------------------------------------
# Core cmdlets demo
Get-Help Get-Command
Get-Help Get-Command –Online
Get-Alias
Set-Alias list Get-ChildItem
Get-Command 
Get-Command –Verb Get
Get-Command –Noun Process
Get-Command –Name *home*
dir | Get-Member
Get-Command | Measure-Object
Get-Command | Out-GridView
get-date | Format-Table
get-date | Format-List

#-------------------------------------------------
# Basics Demo
#Show how to create and retrieve variables 
$dev = “C:\Development”

# Show how to create and retrieve an array
$pets =  $("dog", "cat", "hamster")
$pets = "dog","cat","hamster" 
$pets += “snake”
$pets[2]

# Show how to create and retrieve a hash table
$mypets = @{dog="Dakota"; cat="Tiger"; hamster="Bob"}

# Show how to filter using the where clause 
dir | where name -Like "s*“

# Show how to select specific columns using select-object 
dir | select length
Get-Command | select  * -last 10
get-command | select verb -unique

# Show how to use the pipe symbol 
dir | out-file dir.txt

# Show sort 
$pets | sort
$pets | sort -Unique

# Show the $profile variable
$profile

# Show how to edit your profile
notepad $profile

#-------------------------------------------------
# Execution Control Demo
#Show an if statement 
if ('' -eq 0) { 'equal'} else { 'not equal'}

# Show a for-each statement 
foreach ($a in 1,2,3) { $a * 2 }

# Show While statement 
$a = 5;  while($a -gt 0) { --$a; $a*2 }
 
# Functions Demo
function add($x, $y)
{
    $x + $y
} 
add 3 4

#-------------------------------------------------
# Tips and Tricks Demo
# Show quoting example 
$name=“Brent”
“test $name”
‘test $name’

# Show how to escape a quote in a string 
$welcome = "Welcome `"Brent`"“

# Show an example of using parentheses for a sub-expression 
(4+4).GetType()

# Show how the –WhatIf argument works 
Remove-Item * -WhatIf

#-------------------------------------------------
# Error Handling demo
$ErrorActionPreference = "Continue“ #”Stop”
Try 
{
  2/0
  dir HKLM:
}
Catch [DivideByZeroException] 
{
  “Divide by 0 rrror occurred”
}
Catch 
{
  "Other Exception"
}
Finally 
{
  “Finally executed”
} 

#-------------------------------------------------
# .NET Demo
# Call a static method on a .NET class 
[System.IO.Path]::GetDirectoryName($profile), [math]::pi

#Create an instance of a .NET object 
$test = New-Object System.IO.DriveInfo("c")

#-------------------------------------------------
# Capture services to html file
Get-Service | Sort-Object Status, Name | Select-Object  Status, Name, DisplayName | ConvertTo-Html | Out-File test.html 


