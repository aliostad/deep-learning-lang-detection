function Save-Jpeg (
    [string]$imagePath, 
    [string]$imageOutPut,
    $quality = $(if ($quality -lt 0 -or  $quality -gt 100){throw( "quality must be between 0 and 100.")})
    ){ 
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    $bmp = New-Object System.Drawing.Bitmap $imagePath
    
    #Encoder parameter for image quality 
    $myEncoder = [System.Drawing.Imaging.Encoder]::Quality
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1) 
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($myEncoder, $quality)
    
    # get codec
    $myImageCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()|where {$_.MimeType -eq 'image/jpeg'}
    
    #save to file
    $bmp.Save($imageOutPut,$myImageCodecInfo, $($encoderParams))
} 

function CompressJpegFolder{
      Param( 
        [ValidateScript({Test-Path $_ -PathType 'Container'})] 
        [string] 
        $infolderPath,
        [ValidateScript({Test-Path $_ -PathType 'Container'})] 
        [string] 
        $outfolderPath,
        [ValidateScript({$_ -gt 0 -or  $_ -lt 100})] 
        $quality

    ) 
     
    $allChild = Get-ChildItem $infolderPath -R | Where-Object {($_.Extension -eq ".JPG") -or ($_.Extension -eq ".jpg")}
    $totalCount = $allChild.Count
    Write-Host $totalCount "jpeg files found..."
    $count = 0
    foreach($file in $allChild)
    {
        $count = $count+1
        Write-Host $count "file processed on" $totalCount

        $outFile = Join-Path -Path $outfolderPath -ChildPath ($file.Directory.BaseName + $file.BaseName + ".jpg")

        Save-Jpeg $file.FullName $outFile $quality
    }

   
}


#CompressJpegFolder "C:\Users\benoit\Documents\PhotoCompression\tfv 2010" "C:\Users\benoit\Documents\ldjs" 75