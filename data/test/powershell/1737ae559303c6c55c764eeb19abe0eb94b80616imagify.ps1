# PARAMS
# 1. text to imagify
# 2. font name
# 3. font size
# 4. output
param(  [Parameter(Mandatory=$True, Position=1)]
        [string] $the_string,

        [string] $font="Arial",

        [float]  $size=10.0,

        [string] $out="out.png" )

$foreBrush  = [System.Drawing.Brushes]::White
$backBrush  = [System.Drawing.Brushes]::Black

[system.reflection.assembly]::loadWithPartialName('system') | out-null
[system.reflection.assembly]::loadWithPartialName('system.drawing') | out-null
[system.reflection.assembly]::loadWithPartialName('system.drawing.imaging') | out-null
[system.reflection.assembly]::loadWithPartialName('system.windows.forms') | out-null

# STUFF
# Create font
$nFont = new-object system.drawing.font($font, $size)

# Get size of text $the-string drawn with font $nFont
$sz = [system.windows.forms.textrenderer]::MeasureText($the_string, $nFont)

# Create Bitmap
$bm = new-object system.drawing.bitmap($sz.width, $sz.height)

# Create Graphics
$gr = [System.Drawing.Graphics]::FromImage($bm)

# Paint image's background
$rect = new-object system.drawing.rectanglef(0, 0, $sz.width, $sz.height)
$gr.FillRectangle($backBrush, $rect)

# Draw string, centered
$strFrmt = new-object system.drawing.stringformat
$strFrmt.Alignment = [system.drawing.StringAlignment]::Center
$strFrmt.LineAlignment = [system.drawing.StringAlignment]::Center
$gr.DrawString($the_string, $nFont, $foreBrush, $rect, $strFrmt)

# Close Graphics
$gr.Dispose();

# Save and close Bitmap
$bm.Save($out, [system.drawing.imaging.imageformat]::Png);
$bm.Dispose();
