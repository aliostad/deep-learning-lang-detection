#requires -version 2.0
function Set-ImageFilter {
    <#
        .Synopsis
            Applies an image filter to one or more images
        .Description
            Applies an Windows Image Acquisition filter to one or more Windows Image Acquisition images
        .Example
            $image = Get-Image .\Try.jpg            
            $image = $image | Set-ImageFilter -filter (Add-RotateFlipFilter -flipHorizontal -passThru)
            $image.SaveFile("$pwd\Try2.jpg")
        .Parameter image
            The image or images the filter will be applied to
        .Parameter filter
            One or more Windows Image Acquisition filters to apply to the image
        .Parameter SaveName
            The name under which the file should be saved. If multiple files are specified, 
            a script block should be used to determine the name to be used,  {$_.fullname } will use the file's full name
        .Parameter NoClobber
            This only has an effect when a save name is specified, and ensures an image will not be overwritten     
    #>
   [CmdletBinding(SupportsShouldProcess=$true)]
    param(
    [Parameter(ValueFromPipeline=$true)]
    $image,
    
    [__ComObject[]]
    $filter,
    $SaveName ,
    [switch]$noClobber,
    [switch]$PassThru,
    $psc
    )
    process {
        if ( $psc -eq $null )  { $psc = $pscmdlet }   ; if (-not $PSBoundParameters.psc) {$PSBoundParameters.add("psc",$psc)}
        if (($image -is [System.IO.Fileinfo]) -or
            ($image -is [string])) { $image = Get-image $image}
        if ($image.count -gt 1)    { [Void]$PSBoundParameters.Remove("Image") ;  $Image | ForEach-object {Set-ImageFilter -Image $_ @PSBoundParameters} ; return }
        if (-not $image.LoadFile)  { return }
        $noExtension = $image.FullName -replace "\.$($image.FileExtension)",""
        foreach ($f in $filter) { $image = $f.Apply($image.PSObject.BaseObject) }
        $image = $image | Add-Member NoteProperty FullName "$noExtension.$($Image.FileExtension)" -PassThru 
        if ($saveName) {write-verbose "Saving image to $saveName"
                        $image | Save-image -fileName $saveName -psc $psc -NoClobber:$noclobber
                        if ($passthru) {$image}
        }
        Else           {$image}
    }
}