# Downloads image from helioviewer.
# API: http://helioviewer.org/api/docs/v1/
function GetHelioWallpaper
{
  param (
    [string]$workingDirectory = $pwd.Path ,
    [string]$asOf = $( get-date -uformat "%Y-%m-%dT%H:%M:%SZ" )
  )
  # JP2 API call variables. Change for a different shot.
  $obs = "SDO"
  $ins = "AIA"
  $det = "AIA"
  $meas = "171"
  
  # Create uri.
  $uri = "http://helioviewer.org/api/v1/getJP2Image/?"
    $uri += "date=$asOf"
    $uri += "&observatory=$obs"
    $uri += "&instrument=$ins"
    $uri += "&detector=$det"
    $uri += "&measurement=$meas"
    
  $jp2 = "$workingDirectory\images\web.jp2"
  $webClient = new-object System.Net.WebClient
  $webClient.DownloadFile($uri, "$jp2")
  
  return $jp2
}


# Changes the jp2 wallpaper from helioview to a Windows-usable format and
#  passes convert options directly to convert.
# Pre: a PATHed installation of ImageMagick. http://www.imagemagick.org
#  $jp2: The full path to a jp2 image.
#  $convertOpt: options for Image Magick
function ConvertWallpaper
{
  param (
    [string]$jp2 = $( throw "Parameter jp2 is required" ),
    [string]$convertOpt
  )
  
  $jp2file = get-childitem $jp2
  $png = $jp2file.DirectoryName + "\web.png"  
  convert """$jp2"" $convertOpt ""$png"""
  
  return $png
}


$work = "C:\Program Files\helio-wallpaper"

$jp2 = GetHelioWallpaper $work
$png = ConvertWallpaper $jp2 "-colorize (100,0,0)"

# Changes the wallpaper. 
# Pulled from http://sg20.com/techblog/2011/06/23/wallpaper-changer-command-line-utility/
# Source: https://github.com/philhansen/WallpaperChanger
& "$work\wallpaperchanger\WallpaperChanger.exe" "$png" 4
