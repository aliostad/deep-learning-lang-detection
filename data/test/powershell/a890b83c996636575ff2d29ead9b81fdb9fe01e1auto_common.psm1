#add-type -path "e:\!docs\!projekt\ABB Network Management\source\AutobuildConsole\AutobuildConsoleDocked\AutobuildConsole\bin\Debug\AutobuildPSI.dll"

# Exit with exit code
function exitscript([int]$err,[string]$str,[AutobuildPSI.Property]$property) {
  write-error $str
  $property.p.ret=$err
  return $property
}

# Create config-file from global properties
function createConfig([Hashtable]$config, [String]$conf_path) {
  $file=new-item -itemtype file $conf_path -force
  #add-content $file "_stat {`n  version=""1.4.0""`n}`n"
  $config.GetEnumerator() | foreach-object {
    "{0} {{" -f $_.Key | add-content $file
    $_.Value.GetEnumerator() | foreach-object {
      if ($_.Value -eq "false" -or $_.Value -eq "true") {
        "  {0}={1}" -f $_.Key, $_.Value | add-content $file
      }
      else {
        "  {0}=""{1}""" -f $_.Key, $_.Value | add-content $file
      }
    }
    add-content $file "}`n"
  }
}

function getPerl([String]$path, [String]$path_alt) {
  $ret="$path"
  if(!(test-path $ret))
  {
    $ret="$path_alt"
    if(!(test-path $ret)) {
      return ""
    }
  }
  return $ret
}

function showProject([AutobuildPSI.Property]$property) {
  "Project variables: "
  $property.p.p.GetEnumerator() | foreach-object {
    "  {0,-10}" -f $_.Key
    $_.Value.GetEnumerator() | foreach-object {
      "    {0,-10} -> {1,-10}" -f $_.Key, $_.Value
    }
  }
}

function showGlobal([AutobuildPSI.Property]$property) {
  "Global variables: "
  $property.p.g.GetEnumerator() | foreach-object {
    "  {0,-10}" -f $_.Key
    $_.Value.GetEnumerator() | foreach-object {
      "    {0,-10} -> {1,-10}" -f $_.Key, $_.Value
    }
  }
}

function showAction([AutobuildPSI.Property]$property) {
  "Action variables: "
  $property.p.a.GetEnumerator() | foreach-object {
    "  {0,-10} -> {1,-10}" -f $_.Key, $_.Value
  }
}

function showActionItems([AutobuildPSI.Property]$property) {
  "Action items: "
  $property.p.i.GetEnumerator() | foreach-object {
    "  {0,-10} -> {1,-10}" -f $_.Key, $_.Value
  }
}

function showCustom([AutobuildPSI.Property]$property) {
  "Custom variables: "
  $property.c.param.GetEnumerator() | foreach-object {
    "  {0,-10} -> {1,-10}" -f $_.Key, $_.Value
  }
}

function showSParams($p) {
  "Script parameters: "
  $p | foreach-object {
    "  {0}" -f $_
  }
}

function showOpts($o) {
  "Options (switches): "
  $o | foreach-object {
    "  {0}" -f $_
  }
}

