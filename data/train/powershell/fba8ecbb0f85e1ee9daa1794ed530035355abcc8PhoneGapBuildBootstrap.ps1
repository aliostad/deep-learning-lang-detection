$root = [Environment]::GetFolderPath("Desktop") + "\PhoneGapBuildApp$((get-date).toString('yyyy-MM-dd_HH-mm-ss'))"

md -Path $root
md -Path $root\src
md -Path $root\www
md -Path $root\www\Scripts
md -Path $root\www\Content
md -Path $root\www\App
md -Path $root\www\fonts
Copy-Item config.xml $root\www
Copy-Item Scripts\* $root\www\Scripts -recurse
Copy-Item Content\* $root\www\Content -recurse
Copy-Item fonts\* $root\www\fonts -recurse
Copy-Item App\main-built.js $root\www\App
Copy-Item index.html $root\www