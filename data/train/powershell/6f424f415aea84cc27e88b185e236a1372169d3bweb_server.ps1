# ######################################################################
# Light Http Web Server
# ######################################################################
# 
# ** Run as administrator **
# 
# http://msdn.microsoft.com/en-us/library/system.net.httplistener.aspx
# 
# TODO:
# 
# * Alterar modelo de escrever respostas,
#   tem de meter logo no contexto ...
# ...
# * SOAP (MIME types)
# * Assyncs...
# * Security (Auth, Certificates, ...)
# ...
# * Cookies (...)
# * SCRIPTING: asps, phps, perls, python, ruby, (...), CLISP
# 
# ?!? indexing by search engines ?!?
# 
# 
# ######################################################################

# Configurations #######################################################
. .\base.ps1	

# Configurations: how to handle resource asking ...
. .\rules.ps1

# ######################################################################
# Gerar em memoria a estrutura dos recursos (pastas / ficheiros / ...)
# Maps ... (? Associar 1 queryString a 1 recurso)
# (Regra especial, com regex match no parsing ...)
#
# ...
#

# Load assemblies ######################################################

[reflection.assembly]::loadWithPartialName( "system.net"  )  | out-null
[reflection.assembly]::loadWithPartialName( "system.text" )  | out-null
[reflection.assembly]::loadWithPartialName( "system.io"   )  | out-null
[reflection.assembly]::loadWithPartialName( "system.web"  )  | out-null

# ######################################################################

$script:listener 	= $null
$script:jobId 		= 0

#$script:callback = [system.asyncCallback] {
#		#write-host "cucu!"		
#		#write-host $args
#		
#		if($script:listener -ne $null){
#			# Register ...
#			$listener.beginGetContext( $script:callback, $script:listener)
#		}
#	}

function StartServer(){
	if($script:listener -eq $null -and $script:jobId -eq 0){
		# Setup Listener
		$script:listener = new-object System.Net.HttpListener

		foreach ($prefix in $PREFIXES){ 
			$script:listener.Prefixes.Add($prefix) 
		}

		# Start Listener
		$script:listener.start()

		# This is awefully slow ...
		#$script:jobId = start-job -scriptBlock {
				while( $script:listener -ne $null ){
					$result = $script:listener.getContext()
				
					processContext $result | out-null
					$result
				}
		#	}
		
		$script:jobId = $script:jobId.Id
		#$listener.beginGetContext( $script:callback, $script:listener)
	}
}

function StopServer(){
	if($script:jobId -ne 0){
		remove-job $script:jobId -force
		$script:jobId = 0
	}
	if($script:listener -ne $null){
		# Stop Listener
		$script:listener.stop()
		$script:listener.close()
		$script:listener = $null;
	}
}

# ######################################################################
