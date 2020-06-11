function prep($startdir = "c:\exif\exif\lib\jpgfiles" ){
	cd \EXIFTool 
	$cmd1 = ".\exiftool\" 
	$cmd2 = ".\exiftool.exe " 
	$cmd3 = " -r -fast " 

	$fmt = " -p piped.fmt " 
	$cmd = $cmd2 + $cmd3 + $fmt + " " + $startdir 
	#10 $cmd                                                                                                              
}

function load {
	$h = @{}
	$d = "c:\exif\exif\lib\jpgfiles"

	$raw = ./exiftool.exe -j -m -r -p piped.fmt $d
	$spl = $raw | ? {$_.length -ne 0}| % {		
		$v = @{}
		$str = $_.split("|")
	#	if (! $str -match ":") {
	#		continue
	#	}
		$f1 = $str[0] 
		$v["num"] = 1
		$v["name"] = $str[1]
		$v["size"] = $str[3]
		$v["settings"] = $str[4]
		$v["directory"] = $str[5] 
		if ( ! $h[$f1] ) {
			$h[$f1] = $v
		}else {
			$h[$f1]["num"] += 1
			$h[$f1]["name"] += "|" + $v["name"]
			$h[$f1]["size"] += "|" + $v["size"]
			$h[$f1]["settings"] += "|" + $v["settings"]
			$h[$f1]["directory"] += "|" + $v["directory"] 
		}
		#
	}
	return $h
	#  2008:09:28 13:23:30
#  IMG_2118.jpg
#  num/1
#  4.9 MB
#  (f/10.0, 1/200s, ISO 400)
#  /exif/exif/lib/jpgfiles/TestCopy  
}

function build {
	$a = @{}
	$s = load
	$s.getenumerator() | % {$a[$_[0]]= 1}
	$a
}
$z = load
