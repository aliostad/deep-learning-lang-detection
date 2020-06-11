$root = [Environment]::GetFolderPath("Desktop") 

md -Path $root\PhoneGapBuildApp
md -Path $root\PhoneGapBuildApp\src
md -Path $root\PhoneGapBuildApp\www\js
md -Path $root\PhoneGapBuildApp\www\css
md -Path $root\PhoneGapBuildApp\www\images
Copy-Item ..\..\src\* $root\PhoneGapBuildApp\src -recurse
Copy-Item ..\..\index.html $root\PhoneGapBuildApp\www
Copy-Item ..\..\config.xml $root\PhoneGapBuildApp\www
Copy-Item ..\..\js $root\PhoneGapBuildApp\www -recurse
Copy-Item ..\..\css $root\PhoneGapBuildApp\www -recurse
Copy-Item ..\..\images $root\PhoneGapBuildApp\www -recurse
Copy-Item config.js $root\PhoneGapBuildApp\www\js