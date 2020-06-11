. ".\_setEnv.ps1"

echo "+++ creatApiInstaller +++"

# cleanup the api folder
remove-item $startDir"sally\__apiInstall\include" -recurse -verbose -ErrorAction SilentlyContinue
remove-item $startDir"sally\__apiInstall\lib" -recurse -verbose -ErrorAction SilentlyContinue

# ensure the api folder exists
new-item $startDir"sally\__apiInstall\include\include\sallyAPI\" -type directory -verbose
new-item $startDir"sally\__apiInstall\lib\lib\" -type directory -verbose

# copy the files
copy-item $startDir"sally\sally\sallyAPI\*.h" $startDir"sally\__apiInstall\include\include\sallyAPI\" -verbose

copy-item $startDir"sally\__apiExt\include\*" $startDir"sally\__apiInstall\include\include\" -recurse -verbose
copy-item $startDir"sally\__apiExt\lib\*" $startDir"sally\__apiInstall\lib\lib\" -recurse -verbose

copy-item $startDir"sally\sally\Release\sallyAPI.lib" $startDir"sally\__apiInstall\lib\lib\" -verbose
copy-item $startDir"sally\sally\Release\sallyAPI.pdb" $startDir"sally\__apiInstall\lib\lib\" -verbose

echo "+++ creatApiInstaller - DONE +++"