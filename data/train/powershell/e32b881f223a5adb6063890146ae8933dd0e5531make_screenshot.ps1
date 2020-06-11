[reflection.assembly]::LoadWithPartialName("System.Drawing") > $null
$Bitmap = new-object System.Drawing.Bitmap 1280,1024
$Size = New-object System.Drawing.Size 1280,1024
$FromImage = [System.Drawing.Graphics]::FromImage($Bitmap)
$FromImage.copyfromscreen(0,0,0,0, $Size,
([System.Drawing.CopyPixelOperation]::SourceCopy))
$Bitmap.Save("\\Ubuntu64\sys$\script\screenshot\PrintScreen.png",
([system.drawing.imaging.imageformat]::png)); # the acceptable

