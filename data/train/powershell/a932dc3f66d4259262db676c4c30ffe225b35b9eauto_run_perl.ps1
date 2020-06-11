param([parameter(mandatory=$true,position=0)][AutobuildPSI.Property]$property)
if ($args) {"`$args is $args"}
import-module .\auto_common.psm1
#---------------------------------

# Get path to Perl
$perl=getPerl $property.p.g.main.perl_path $property.p.g.main.perl_path_alt
if(-not($perl)) {
  return exitscript 1 "Perl not defined or not found." $property
}

# Check important paths definitions
if(-not($property.p.g.main.temp_path)) {
  return exitscript 1 "Temporary path not defined." $property
}
if(-not($property.p.g.main.logs_path)) {
  return exitscript 1 "Logs path not defined." $property
}
if(-not($property.p.g.main.hub_path)) {
  return exitscript 1 "Hub path not defined." $property
}
if(-not($property.p.g.main.conf_file_path)) {
  return exitscript 1 "Config-file name not defined." $property
}

# Retrieve parameters and choices
$script=(get-location).path + "\" + $property.p.a.script
if(-not(test-path $script)) {
  return exitscript 1 "Cannot find script file: $script." $property
}
# Retrieve script parameters
$sparams=@()
if($property.p.a.params) {
  $sparams=$property.p.a.params.split(",")
}
# Retrieve options (switches)
$opts=new-object "System.Collections.Generic.List``1[System.String]"
$property.p.a.GetEnumerator() | foreach-object {
  if($_.Key -ne "script" -and $_.Key -ne "params") {
    if($_.Value -ne "False") {
      if($_.Value -eq $null -or $_.Value -eq "True") { $opts.Add("-" + $_.Key) }
      else { $opts.Add("-" + $_.Key + '="' + $_.Value + '"') }
    }
  }
}

# Create parameter list
$temp_path=$property.p.g.main.temp_path
$logs_path=$property.p.g.main.logs_path
$hub_path=$property.p.g.main.hub_path
$conf_file_path=$property.p.g.main.conf_file_path
$params=@("-print_formatted", "-c=`"$conf_file_path`"", "-t=`"$temp_path`"", "-l=`"$logs_path`"", "-hub=`"$hub_path`"")
if($property.c.param.iconf -ne $null -and $property.c.param.iconf -ne "") {
  $params += "-iconf=" + $property.c.param.iconf
}

# Create the config-file from the project properties
createConfig $property.p.p $conf_file_path

#showProject $property
#showGlobal $property
#showAction $property
#showActionItems $property
#showCustom $property
#showSParams $sparams
#showOpts $opts

# Add some vars to custom
$property.c.param.myown="This is a test message"
$property.c.param.mysts="This is a status message"
# Temporary --------------

# Run Perl script
if($property.p.a.ContainsKey("streamed")){
  # Get streamed data from call
  #"Run: $perl $script $sparams $params $opts"
  $ret=& $perl $script $sparams $params $opts
  # Store returned value in custom area
  $property.c.param.iconf=$ret
}
else {
  # Normal call
  #"Run: $perl $script $sparams $params $opts"
  & $perl $script $sparams $params $opts 
}

#---------------------------------
$property.p.ret=$LastExitCode
return $property
