# If full path, save. Else, append path of current working dir
if($args[0] -Match "\\")
{
   $dir = $args[0]
}
else
{
   $dir = $MyInvocation.MyCommand.Path | split-path
   $dir += "\$args"
}

$regex = '\.*[åøæÅÆØ].*\b'

get-childitem $dir -rec |where {!$_PSIsContainer} | select-object FullName | select-string  $regex