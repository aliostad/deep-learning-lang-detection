param ($srcPattern="deb*.tif")
dir $srcPattern | 
	%{
		$destPath=($_.FullName -replace '.tif','.jpg')
		$dest=new-object System.IO.FileInfo $destPath
		if (!$dest.Exists) { 
			$_
			$image=[System.Drawing.Image]::FromFile($_); 
			$image.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Jpeg) 
		}
	}
