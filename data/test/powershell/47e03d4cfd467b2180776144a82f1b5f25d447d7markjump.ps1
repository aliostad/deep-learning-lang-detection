#
## (Leon Bambrick's Powershell implementation of) Mark & Jump!
## inspired by this: http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
## 
## MIT License.
## dot this file (for example add this to your $profile: ". .\markjump.ps1")
## 
## USAGE
## > mark "fred"   <-- mark the current location as "fred"
## > marks         <-- list all marks.
## > jump "fred"   <-- cd to the location denoted by fred
## > unmark "fred" <-- remove "fred" from the list of marks.
## 
## "Note that marks are persisted across sessions. They are permanenty!"

$marks = $null;
# four shell functions jump, mark, unmark, and marks:

# jump to a folder
function jump($name) {
  if ($name -eq $null) {
    marks;
    # also display help.
    return;
  }

  $target = $marks[$name];
  if ($target -ne $null -and (test-path $target)) { set-location $target;}
}

# mark the current folder...
function mark([string]$name) {
  if ($name -eq "") {
    marks;
    # also display help.
    return;
  }

  $target = $marks[$name];
  if ($target -eq $null) {  
	get-location | % { $marks[$name] = $_.Path }
  } else {
    'mark already exists. need to unmark first. or maybe you want to jump?'
	return;
  }
  save-marks;
}

# unmark the current folder
function unmark([string]$name) {
  if ($name -eq "") {
    marks;
    # also display help.
    return;
  }

  $marks.Remove($name);
  save-marks;
}

function marks() {
  # list all marks (TODO: if no marks, maybe display help.
  $marks.GetEnumerator() | sort Name | ft -autosize
}

# 3 Local functions... save-marks, Load-marks and ConvertTo-Hash

# save-marks: these are persisted the the marks.json file
function Local:save-marks() {
  if (Get-Command "ConvertTo-Json" -errorAction SilentlyContinue) {
    ConvertTo-Json $marks > $env:localappdata"\marks.json"
  } else {
    #"can't save it there..."
	$marks | export-clixml $env:localappdata"\marks.clixml"
  }
}

# initialize the $marks variable from the marks.json file (or create the file if necessary)
function Local:Load-marks() {
 if (Get-Command "ConvertTo-Json" -errorAction SilentlyContinue) {
   if ((test-path $env:localappdata"\marks.json") -eq $false) { 
      $script:marks = @{};
      save-marks;
   }
   $script:marks = ((Get-Content $env:localappdata"\marks.json") -join "`n" | ConvertFrom-Json)
   $script:marks = ConvertTo-Hash $script:marks
   
  } else {

    if ((test-path $env:localappdata"\marks.clixml") -eq $false) { 
      $script:marks = @{};
      save-marks;
   }
   $script:marks = (import-clixml $env:localappdata"\marks.clixml")
   
  }
  if ($script:marks -eq $null) {
    $script:marks = @{};
  }
}

# ConvertTo-Hash is used by Load-marks to convert the custom psObject into a hash table.
function Local:ConvertTo-Hash($i) {
    $hash = @{};

    $names = $i | Get-Member -MemberType properties | Select-Object -ExpandProperty name 
    if ($names -ne $null) {
        $names | ForEach-Object { $hash.Add($_,$i.$_) }
    } 
    $hash;
}

## markjump_help    -- this output
function markjump_help() {
 $x = (& { $myInvocation.ScriptName })
 type $x | ? { $_ -like "## *"}  | % { $_.TrimStart("#") }
}

Local:Load-marks;

## Recommended aliases:
##   m -> mark
##   j -> jump
##   um -> unmark
set-alias m mark
set-alias um unmark
set-alias j jump