#requires -version 2.0
function Get-Image {
    <#
        .Synopsis
            Returns an image object for a file
        .Description
            Uses the Windows Image Acquisition COM object to get image data
        .Example
            Get-ChildItem $env:UserProfile\Pictures -Recurse | Get-Image        
        .Parameter file
            The file to get an image from
    #>
    param(    
    [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
    [Alias('FullName')]
    [string]$file)
    
    process {
        $realItem = Get-Item $file -ErrorAction SilentlyContinue     
        if (-not $realItem) { return }
        $image  = New-Object -ComObject Wia.ImageFile        
        try {        
            $image.LoadFile($realItem.FullName)
            $image | 
                Add-Member NoteProperty FullName $realItem.FullName -PassThru | 
                Add-Member ScriptMethod Resize {
                    param($width, $height, [switch]$DoNotPreserveAspectRatio)                    
                    $image = New-Object -ComObject Wia.ImageFile
                    $image.LoadFile($this.FullName)
                    $filter = Add-ScaleFilter @psBoundParameters -passThru -image $image
                    $image = $image | Set-ImageFilter -filter $filter -passThru
                    Remove-Item $this.Fullname
                    $image.SaveFile($this.FullName)                    
                } -PassThru | 
                Add-Member ScriptMethod Crop {
                    param([Double]$left, [Double]$top, [Double]$right, [Double]$bottom)
                    $image = New-Object -ComObject Wia.ImageFile
                    $image.LoadFile($this.FullName)
                    $filter = Add-CropFilter @psBoundParameters -passThru -image $image
                    $image = $image | Set-ImageFilter -filter $filter -passThru
                    Remove-Item $this.Fullname
                    $image.SaveFile($this.FullName)                    
                } -PassThru | 
                Add-Member ScriptMethod FlipVertical {
                    $image = New-Object -ComObject Wia.ImageFile
                    $image.LoadFile($this.FullName)
                    $filter = Add-RotateFlipFilter -flipVertical -passThru 
                    $image = $image | Set-ImageFilter -filter $filter -passThru
                    Remove-Item $this.Fullname
                    $image.SaveFile($this.FullName)                    
                } -PassThru | 
                Add-Member ScriptMethod FlipHorizontal {
                    $image = New-Object -ComObject Wia.ImageFile
                    $image.LoadFile($this.FullName)
                    $filter = Add-RotateFlipFilter -flipHorizontal -passThru 
                    $image = $image | Set-ImageFilter -filter $filter -passThru
                    Remove-Item $this.Fullname
                    $image.SaveFile($this.FullName)                    
                } -PassThru |
                Add-Member ScriptMethod RotateClockwise {
                    $image = New-Object -ComObject Wia.ImageFile
                    $image.LoadFile($this.FullName)
                    $filter = Add-RotateFlipFilter -angle 90 -passThru 
                    $image = $image | Set-ImageFilter -filter $filter -passThru
                    Remove-Item $this.Fullname
                    $image.SaveFile($this.FullName)                    
                } -PassThru |
                Add-Member ScriptMethod RotateCounterClockwise {
                    $image = New-Object -ComObject Wia.ImageFile
                    $image.LoadFile($this.FullName)
                    $filter = Add-RotateFlipFilter -angle 270 -passThru 
                    $image = $image | Set-ImageFilter -filter $filter -passThru
                    Remove-Item $this.Fullname
                    $image.SaveFile($this.FullName)                    
                } -PassThru 
                
        } catch {
            Write-Verbose $_
        }
    }    
}