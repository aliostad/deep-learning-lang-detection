clear

if($args.Length -ne 2) { return -100 }
$configuration = $args[0].ToLower()
$sourceDir = $args[1].ToLower()

if($configuration -ne "release") { return }

$destinationDir = "f:\Release\VKUsersCollector"
md $destinationDir -ErrorAction:SilentlyContinue
del $destinationDir\*.*

copy $sourceDir*.dll -Destination $destinationDir -Exclude *.vshost.*
copy $sourceDir*.ini -Destination $destinationDir
copy $sourceDir*.config -Destination $destinationDir -Exclude *.vshost.*
copy $sourceDir*.exe -Destination $destinationDir -Exclude *.vshost.*
