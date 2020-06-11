dir *.jpg | 
    Get-Random | 
    Get-image | 
    ForEach-Object {
        $image = $_
        $filter = Add-ScaleFilter -width 1000 -height 1000 -passThru |
            Add-CropFilter -top 200 -left 200 -bottom 10 -right 10 -passThru | 
            Add-RotateFlipFilter -angle 90 -passThru
        $image = $image | Set-ImageFilter -filter $filter -passThru
        $p = "$pwd\$(Get-Random).jpg"
        $image.SaveFile("$p")
        Invoke-Item $p
    }