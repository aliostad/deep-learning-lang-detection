param($cmd, $ShowCount = 10)
function Internal-Change-Directory($cmd, $ShowCount){

	function Get-CommandList() {
		(Get-Location -Stack).ToArray() | sort Path -Unique
	}

	function Print-Extended-CD-Menu(){
		$index = 1;
		foreach($location in Get-CommandList){
			if($index -eq 0) {
				Write-Host ("{0,6}) {1}" -f $index, $location)
			}
			else {
				Write-Host ("{0,6}) {1}" -f $index, $location)
			}
			$index++
			if($index -gt $ShowCount){
				break;
			}
		}
	}

	switch($cmd) {
		"" { Print-Extended-CD-Menu }
		"?" { Print-Extended-CD-Menu }
		default {

			$newLocation = $cmd;

			# check to see if we're using a number command and get the correct directory.
			[int]$cdIndex = 0;
			if([system.int32]::TryParse($cmd, [ref]$cdIndex)) {
				$results = (Get-CommandList);
				if( ($results | measure).Count -eq 1 ){
					$newLocation = $results
				}
				else {
					$newLocation = (Get-CommandList)[$cdIndex-1]
				}
			}

			#If we are actually changing the dir.
			if($pwd.Path -ne $newLocation){
				Push-Location $newLocation
			}
		}
	}
}

Internal-Change-Directory -cmd $cmd -ShowCount $ShowCount
