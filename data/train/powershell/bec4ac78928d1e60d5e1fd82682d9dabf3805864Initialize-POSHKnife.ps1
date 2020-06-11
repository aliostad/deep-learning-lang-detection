<#
Copyright 2014 ASOS.com Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>


function Initialize-POSHKnife {

	<#

	.SYNOPSIS
	Configure the installation of POSHChef

	.DESCRIPTION
	For a machine to be configured as a Chef workstation 4 bits of information are required

		Chef Server
		Client name (not the same as the web username)
		Path to client key
		Path to cookbooks (if not specified this will be set to the <BASEDIR>\cookbooks

	If Invoke-ChefClient is run without this being done first it will run an interactive session asking
	questions about what is required.  As this needs to be scripts, this function provides a way to
	programmatically provide this information

	The key that is required is one that will have been created on the chef server.
	Without this key it is not possible to manage cookbooks in chef using this tool.

	.EXAMPLE

	Intialize-POSHKnife -server "https://chef.local" -client fred -clientkey c:\temp\fred.pem

	Will create the necessary folder structure under C:\POSHChef and will copy the client key to C:\POSHChef\conf\client.pem
	The knife.psd1 file is created with the specified configuration.

	#>

	[CmdletBinding()]
	param (

		[string]
		# URL of Chef server
		$server,

		[string]
		[alias("username")]
		# Name of the node as it will be stored in Chef
		$client,

		[int]
		# Number of logs to keep
		$keeplogs = 20,

		[string]
		# Path to the client key.
		$key,

		[string]
		# Sub folder in the conf directory that the key should be stored in
		$keydir = [String]::Empty,

		[string]
		# Base directory where POSHChef files are stored
		$basedir = "C:\POSHChef",

		[string]
		[alias("repo")]
		# Path to the chef repo that holds the cookbooks, roles, environments etc
		$chef_repo = [String]::Empty,

		[string]
		# Name of the configuration file
		# By default this will be knife.psd1
		$name = [String]::Empty,

		[string]
		# Set the API version to use when communicating with the chef server
		$apiversion = "12.0.2",

		[switch]
		# Whether to force an override on an existing file
		$force,

		[switch]
		# Specify if the key should be kept in the same place
		$nocopykey,

		[string]
		# The Supermarket API endpoint to use
		$supermarket_url = "https://supermarket.chef.io/api/v1"
	)

	# Set log paraneters so that we have access to the help file
	Set-LogParameters -helpfile ("{0}\..\..\lib\POSHChef.resources" -f $PSScriptRoot)

	Write-Log -Eventid PC_INFO_0006 -extra ((Get-Module -Name POSHChef).Version.ToString())

	Write-Log -EventId PC_INFO_0026

	# Check the cookbook path and if it is empty set it based on the basedir
	if ([String]::IsNullOrEmpty($chef_repo)) {
		$cookbook_path = "{0}\chef_repo" -f $basedir
	}

	# mandatory parameters hashtable
	$mandatory = @{
		server = "Chef server to use (-server)"
		client = "Name of the client / username (-client)"
		key = "Key file for the named client (-key)"
		"chef_repo" = "Path to Chef Repo on disk (-chef_repo)"
	}

	# Patch the $PSBoundParameters to contain the default values
	# if they have not been explicitly set
	foreach ($param in @("server", "client", "key", "keeplogs", "basedir", "chef_repo")) {
		if (!$PSBoundParameters.ContainsKey($param)) {
			$PSBoundParameters.$param = (Get-Variable -Name $param).Value
		}
	}

	# Check that mandatory parameters have been set
	Confirm-Parameters -parameters $PSBoundParameters -mandatory $mandatory

	# Initialize a session to that we can use the paths that are setup accessible
	Update-Session -parameters $PSBoundParameters

	# Build up an object to pass to the Setup-ConfigFiles function to configure the conf file
	# for Chef
	$userconfig = @{
		server = $server
		node = $client
		logs = @{
			keep = $keeplogs
		}
		chef_repo = $chef_repo
		client_key = $key
		apiversion = $apiversion
		supermarket_url = $supermarket_url
	}

	# Create the argument hashtable to splat into the Setup-Configfiles function
	$splat = @{
		type = "knife"
		name = $name
		userconfig = $userconfig
		force = $force
		keydir = $keydir
		nocopykey = $nocopykey
	}

	Setup-ConfigFiles @splat

}
