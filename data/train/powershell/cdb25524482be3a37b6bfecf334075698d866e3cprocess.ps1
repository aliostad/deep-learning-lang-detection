

####################################
#user preferences
####################################


<#
Specify the BaseNames of javascript files to minify eg @('bigfont')
#>
$arrTargetJavascriptFiles = @('bigfont');


<#
Specify the BaseNames of less files to compile eg @('bootstrap', 'responsive', 'bigfont')
#>
$arrTargetLessFiles = @('bootstrap', 'responsive', 'bigfont');


<#
Set to true if you want to optimize or resize images, which takes some time.
#>
$doOptimizeImages = $false;
$doResizeImages = $false;










####################################
#retrieve paths, modules, and executables
####################################

#retrieve relevant paths and directories
$scriptPath = $MyInvocation.MyCommand.Path;
$scriptDir = Split-Path $scriptPath;
$scriptParentDir = Split-Path -parent $scriptDir; 
$assetsDir = Get-ChildItem $scriptParentDir -Directory | Where-Object { $_.Name -match 'assets-\d*$' }
$siteAssetsDir = Get-ChildItem $assetsDir.FullName -Directory | Where-Object { $_.Name -match 'site$' }

#import modules
Import-Module (".\modules\minJS\minJS");
Import-Module (".\modules\image\Image.psm1");

#import executable
$fileOpt = Get-ChildItem -recurse | 
    Where-Object { $_.Name -match 'FileOptimizer64.exe'}










####################################
#process lesscss
####################################
Write-Host("`n");
Write-Host('processing lesscss')

#get all the less files in the assets directory
$lessFiles = Get-ChildItem $assetsDir.FullName -recurse -include *.less | 
    Where-Object { $arrTargetLessFiles -contains $_.BaseName }

if($lessFiles.Count -eq 0)
{
    Write-Host('please specify .less files to compile.');
}

foreach ($file in $lessFiles)
{          
    #create the css save directory if it doesn't exist
    $saveDirectory = $file.DirectoryName -replace 'less$', 'css';
    if(!(Test-Path $saveDirectory))
    {
        New-Item -ItemType directory -Path $saveDirectory
    }
    
    $savePath = $saveDirectory + '\' + $file.BaseName + '.min.css';    
    lessc -x $file.FullName > $savePath; #this runs lessc -x filename.less > filename.min.css  
    Write-Host($savePath);
}








####################################
#process js
####################################
Write-Host("`n");
Write-Host('processing js')

$jsFiles = Get-ChildItem $assetsDir.FullName -recurse -include *.js -exclude *.min.js | 
    Where-Object { $arrTargetJavascriptFiles -contains $_.BaseName }

if($jsFiles.Count -eq 0)
{
    Write-Host('please specify .js files to minify.');
}

foreach ($file in $jsFiles)
{           
    $str = Get-Content -Path $file.FullName;
    $min = (minify -inputData $str -inputDataType "js");    
    $savePath = ($file.FullName -replace "`\.js", '.min.js');    
    $min | Out-File $savePath;    
    Write-Host($savePath);
}










####################################
#resize images
####################################
Write-Host("`n");
Write-Host('resizing images')

if($doResizeImages)
{
    $resizedDirName = 'resized';

    $imgFiles = Get-ChildItem $siteAssetsDir.FullName -recurse -include *.png, *jpeg, *jpg | 
        Where-Object { $_.DirectoryName -notmatch ($resizedDirName + '$') }

    if($imgFiles.Count -eq 0)
    {
        Write-Host('please specify image files to resize.');
    }

    #set target widths
    $largeWidth = 1200;
    $desktopWidth = 980;
    $portraitTabletWidth = 768;
    $phoneToTabletWidth = 480;
    $phoneWidth = 320;

    #set target suffixes for save
    $largeSuffix = '-resizeLarge';
    $desktopSuffix = '-resizeDesktop';
    $portraitTabletSuffix = '-resizePortraitTablet';
    $phoneToTabletSuffix = '-resizePhoneToTablet';
    $phoneSuffix = '-resizePhone';
    
    foreach ($file in $imgFiles)
    {                
        $image = $file | Get-image;    
    
        $aspectRatio = $image.Height / $image.Width;

        #create the resized directory for this folder, if it doesn't exist
        $saveDirectory = $file.DirectoryName + '\' + $resizedDirName;    
        if(!(Test-Path $saveDirectory))
        {
            New-Item -ItemType directory -Path $saveDirectory
        }   

        #determine where to stuff the suffix
        $suffixStuffIndex = $file.Name.LastIndexOf('.');

        #function to adhere to DRY principles
        Function ResizeAndRenameImage($newWidth, $newSuffix)
        {
            $newHeight = $aspectRatio * $newWidth;           
              
            #set the savePath
            $savePath = $saveDirectory + '\' + $file.Name.Insert($suffixStuffIndex, $newSuffix);                                                
            if(Test-Path $savePath)
            {
                #file exists so delete it before save.
                #odd that we cannot over write an existing file.
                Remove-Item $savePath;
            }
        
            $image = $image | Set-ImageFilter -filter (Add-ScaleFilter -Width $newWidth -Height $newHeight -passThru) -passThru                    
            $image.SaveFile($savePath);
            Write-Host($savePath);
        }

        #call the function above for all the sizes.
        ResizeAndRenameImage $largeWidth $largeSuffix
        ResizeAndRenameImage $desktopWidth $desktopSuffix
        ResizeAndRenameImage $portraitTabletWidth $portraitTabletSuffix
        ResizeAndRenameImage $phoneToTabletWidth $phoneToTabletSuffix
        ResizeAndRenameImage $phoneWidth $phoneSuffix
    }
}
else
{
    Write-Host('please opt in to resize images');
}














####################################
#optimize images
####################################
Write-Host("`n");
Write-Host('optimizing images');

$pngOutFullPath = "C:\Users\Shaun\Documents\GitHub\MarillDesign\MarillDesign\MarillDesign\assetsOptimizer-Process-v20130608-1\executables\fileOptimizer\Plugins64\pngout.exe";


if($doOptimizeImages) 
{                      

$imgFiles = Get-ChildItem $siteAssetsDir.FullName -recurse -include *.png, *jpeg, *jpg

foreach ($file in $imgFiles)
{
    #process .png files
    if($file.Extension -eq '.png')
    {                          
        Write-Host($file.FullName)
        Start-Process $pngOutFullPath -argumentList $file.FullName -wait
    }    
}

} 
else 
{
    Write-Host('please opt in to image optimization');
}












####################################
#prevent exiting
####################################
Write-Host("`n");
Write-Host('Press any key to exit.')
Read-Host
Exit






