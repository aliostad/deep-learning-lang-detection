
function localLoadAsModule( $script_block ){
	$name = "MODULE_" + $script_block.toString().getHashCode().toString();
	localLoadAsModulewName $script_block $name 
}

function localLoadAsModulewName( $script_block, $name ){
	$dll = new-module -name $name -scriptBlock $script_block
	# Remove existings first ...
	get-module | where { $_.name -eq $name } | foreach { remove-module -moduleinfo $_ }
	import-module -moduleInfo $dll -global
}

# Main
$code = {
	
	# I found no better way to do this .... those two functions must be on the inside and on the outside
	function localLoadAsModule( $script_block ){
		$name = "MODULE_" + $script_block.toString().getHashCode().toString();
		localLoadAsModulewName $script_block $name 
		#write-host " ... and after ..."
		#get-module
	}

	function localLoadAsModulewName( $script_block, $name ){
		$dll = new-module -name $name -scriptBlock $script_block
		# Remove existings first ...
		get-module | where { $_.name -eq $name } | foreach { remove-module -moduleinfo $_ }
		import-module -moduleInfo $dll -global
		#write-host "Loading ..."
		#get-module
	}
	
	###

	function LoadFile( $filename ){ LoadFilewName $filename $filename }
	
	function LoadFilewName( $filename, $name){
		$code = [system.io.file]::readAllText( $filename )
		$script_block = [System.Management.Automation.ScriptBlock]::Create( $code )
		LoadScriptwName $script_block  $name
	}

	function LoadScript( $script_block ){ localLoadAsModule( $script_block ) }
	
	function LoadScriptwName( $script_block, $name ){ localLoadAsModule $script_block $name }

	export-modulemember -Function LoadScript, LoadScriptwName, LoadFile, LoadFilewName
}

# Load itself in memory
localLoadAsModule($code)