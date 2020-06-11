# edit root dir and mode (debug vs release)
$root_dir = 'D:\stay-notified-app\StayNotified\'
$mode = 'Debug'

# build paths
$lib_dir = $root_dir + 'NotificationLibrary\'
$api_dir = $root_dir + 'NotificationAPI\'
$output_dir = $api_dir + 'bin\' + $mode
$site = 'site'
$sources = $lib_dir +'sources'

# copy static site files
$path = $api_dir + $site
$dest = $output_dir
Copy-Item -Path $path -Destination $dest -force -recurse

# copy source files - needed in bin/mode now
$path = $sources
$dest = $output_dir
Copy-Item -Path $path -Destination $dest -force -recurse

# TODO: encrypt config
