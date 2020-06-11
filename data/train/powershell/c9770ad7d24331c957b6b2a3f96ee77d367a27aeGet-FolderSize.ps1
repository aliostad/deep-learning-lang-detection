function Get-FolderSize {
    param(
        $path = $(pwd)
    )
    $folders = @(gci $path -recurse | Where-Object { $_.PSIsContainer })
    $folders | % {
		$foldersize = 0
        $details = gci $_.Fullname | Measure -Sum Length -ErrorAction silentlycontinue
	    if($($foldersize / 1MB)) {
			$foldersize = $details.sum
	    } else {
			$foldersize = 0
	    }
        $message = "`"$($_.Fullname)`" contains $($details.Count) items taking " + "{0:N2}" -f $($foldersize / 1MB) + " MB"
        Write-Output $message
    }

}

#Get-FolderSize