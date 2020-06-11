# To use this library, you need to include

# . $libDir/repoInstall.sh
# . $libDir/getRepo.sh
# . $libDir/repoParms.sh
# . $libDir/packages.sh
# . $libDir/installLibs.sh

function installRepo
{
	repoAddress="$1"
	overRideRepoName="$2"
	
	installRepo_get "$repoAddress" "$overRideRepoName"
	installRepo_setup "$repoName"
}

function installRepo_get
{
	repoAddress="`echo \"$1\" | sed 's/=.*//g'`"
	repoVersion="`echo \"$1\" | sed 's/.*=//g'`"
	if [ "$repoAddress" == "$repoAddress" ]; then
		repoVersion=''
	fi
	overRideRepoName="$2"
	
	
	# Get it
	checkoutDir="repoInstall-$$"
	addRepo "$repoAddress" "$checkoutDir"
	
	cd "$configDir/repos/$checkoutDir"
	
	
	# get the name
	if [ "$overRideRepoName" == '' ]; then # detect name
		name=`repoGetParm "$checkoutDir" . name`
	else # override name
		echo "installRepo_get: Overrode repoName. This may lead to pain. If you haven't already, read the help for repoInstall." >&2
		name="$overRideRepoName"
	fi

	if [ "$name" == "" ]; then
		echo "installRepo_get: The repository at \"$repoAddress\" does not appear to have a name set. You'll need to do this installation manually."
		removeRepo "$checkoutDir"
		exit 1
	fi
	
	
	# detect conflict
	if repoExists "$name"; then # clean up and warn
		echo "$scriptName: A repo of name \"$name\" is already installed. Re-installing." >&2
		removeRepo "$checkoutDir"
	else
		renameRepo "$checkoutDir" "$name"
	fi
	
	
	# Choose a specific version (if requested)
	cd "$configDir/repos/$name"
	if [ "$repoVersion" != '' ]; then
		echo "installRepo_get: Setting $name to $repoVersion"
		git checkout "$repoVersion"
	fi
	
	export repoName="$name"
}

function installRepo_clean
{
	irs_repoName="$1"
	if [ ! -e "$configDir/repos/$irs_repoName" ]; then
		echo "Repo \"$irs_repoName\" is not currently installed." >&2
		return 1
	fi
	
	while read profileRefName; do
		if [ "$profileRefName" != '' ]; then
			# Get the logical name of the profile
			profileName=`repoGetParm "$irs_repoName" "$profileRefName" "name"`
			
			# create profile
			createProfile "$profileName"
			
			# disable packages
			if [ "$irs_repoName" != 'achel' ] ; then
				disablePackage "$profileName" ".*" ".*"
			fi
		else
			echo "installRepo_setup: profileRefName=\"$profileRefName\""
		fi
	done < <(repoGetProfiles "$irs_repoName")
}

function installRepo_setup
{
	irs_repoName="$1"
	echo "installRepo_setup: Going to setup \"$irs_repoName\""
	if [ ! -e "$configDir/repos/$irs_repoName" ]; then
		echo "Repo \"$irs_repoName\" is not currently installed." >&2
		return 1
	fi
	
	
	# Handle documentation
	# It needs to happen here (instead of in the getRepo library) so that we have the name available.
	documentationAddRepo "$irs_repoName"
	
	# Handel the subplimentary stuff
	supplimentaryInstall "$irs_repoName"
	
	
	while read profileRefName; do
		if [ "$profileRefName" != '' ]; then
			# Get the logical name of the profile
			profileName=`repoGetParm "$irs_repoName" "$profileRefName" "name"`
			execName=`repoGetParm "$irs_repoName"  "$profileName" execName`
			
			# create profile
			createProfile "$profileName"
			
			# enable packages
			while read srcRepoName regex; do
				echo "installRepo_setup($irs_repoName/$profileRefName): Doing enabledPacakge "$srcRepoName" "$regex" "$profileName""
				enabledPacakge "$srcRepoName" "$regex" "$profileName"
			done < <(repoGetParmPackages "$irs_repoName" "$profileRefName")
			
			# Make sure all broken stuff is gone
			cleanProfile "$profileName"
			
			# create executable
			if [ ! "$execName" == '' ]; then
				createExec "$execName" "$irs_repoName"
				$binExec/$execName --verbosity=2 --finalInstallStage
				
				# TODO If there is no execName, see if the profileName matches an existing repo. If so flag that repo for reInstall
			fi
			
			# clear cache
			clearCache "$profileRefName"
			
			# Handel documentation
			documentationAddProfile "$profileRefName"
		else
			echo "installRepo_setup: profileRefName=\"$profileRefName\""
		fi
	done < <(repoGetProfiles "$irs_repoName")
}

function supplimentaryInstall
{
	local si_repoName="$1"
	local si_prefix="$configDir/repos/$si_repoName"
	if [ ! -e "$si_prefix" ]; then
		echo "supplimentaryInstall: Repo \"$si_repoName\" is not currently installed." >&2
		return 1
	fi
	
	if [ ! -e "$si_prefix/supplimentary" ]; then
		echo "supplimentaryInstall: Repo \"$si_repoName\" does not have a supplimentary directory, so there's no need to install one." >&2
	fi
	
	# echo "supplimentaryInstall: First, let's uninstall any files for this repo."
	supplimentaryUninstall "$si_repoName"
	
	# echo "supplimentaryInstall: Now we install any scripts in \""$si_prefix/supplimentary"\"."
	cd "$configDir/supplimentary"
	while read fileName;do
		if [ ! -e "$fileName" ]; then
			# echo "supplimentaryInstall: Adding symlink for \"$fileName\"."
			ln -s "$si_prefix/supplimentary/$fileName" .
		fi
		
	done < <(ls -1 "$si_prefix/supplimentary" 2>/dev/null)
	
	cd "$configDir/supplimentary/libs"
	while read fileName;do
		if [ ! -e "$fileName" ]; then
			# echo "supplimentaryInstall: Adding symlink for \"$fileName\"."
			ln -s "$si_prefix/supplimentary/libs/$fileName" .
		fi
		
	done < <(ls -1 "$si_prefix/supplimentary/libs" 2>/dev/null)
	
	cd ~-
}

function supplimentaryUninstall
{
	local su_repoName="$1"
	local su_prefix="$configDir/repos/$su_repoName"
	local su_supplimentaryDir="$configDir/supplimentary"
	local su_refine="/$su_repoName/"
	if [ ! -e "$su_prefix" ]; then
		echo "supplimentaryUninstall: Repo \"$su_repoName\" is not currently installed." >&2
		return 1
	fi
	
	# echo "supplimentaryUninstall: Removing scripts in \"$su_supplimentaryDir\" matching regex \"/$su_repoName/\"."
	cd "$configDir/supplimentary"
	while read fileName symlinkSrc;do
		# echo "supplimentaryUninstall: Removing symlink \"$fileName\" which points to \"$symlinkSrc\" because it belongs to the repository \"$su_repoName\"."
		rm "$fileName"
	done < <(resolveSymlinks "$su_supplimentaryDir" | grep "$su_refine")
	cd ~-
	
	cd "$configDir/supplimentary/libs"
	while read fileName symlinkSrc;do
		# echo "supplimentaryUninstall: Removing symlink \"$fileName\" which points to \"$symlinkSrc\" because it belongs to the repository \"$su_repoName\"."
		rm "$fileName"
	done < <(resolveSymlinks "$su_supplimentaryDir/libs" | grep "$su_refine")
	cd ~-
}

function userUninstallRepo
{
	repo="$1"
	overRideRepoName="$2"
	
	repoName=`findRepo "$repo"`
	returnValue=$?
	userUninstallRepo_confirm "$repoName" $returnValue "$overRideRepoName"
	
	if [ "$?" -eq 0 ]; then
		supplimentaryUninstall "$repoName"
		uninstallRepo_removeBindings "$repoName"
		removeRepo "$repoName"
	fi
}

function userUninstallRepo_confirm
{
	repoResults="$1"
	repoValue=$2
	overRideRepoName="$3"
	
	
	if [ "$repoResults" == '' ]; then
		echo "No results found for the search \"$repo\". Try repoList to get some clues." >&2
		exit 1
	fi

	echo "$repoResults" | formatRepoResults

	if [ $repoValue -eq 0 ]; then
		repoName=$repoResults
		if [ "$overRideRepoName" == '--force' ]; then
			echo "--force was specified, so will not ask for confirmation." >&2
		else
			if ! confirm "Do you want to uninstall the \"$repoName\" repository?"; then
				echo "User abort." >&2
				exit 1
			fi
		fi
	else
		echo "Too many results. Please refine your search to get one result." >&2
		exit 1
	fi
}

function uninstallRepo_removeBindings
{
	repoName="$1"
	
	while read profileName; do
		if [ "$profileName" != '' ]; then
			# remove executable
			execName=`repoGetParm "$repoName" "$profileName" execName`
			echo "uninstallRepo_removeBindings: Will remove profile '$profileName' for repo '$repoName' with executable '$execName'"
			
			# TODO the input protection will likely be a curse here, so should be revised.
			removeExec "$execName"
			
			# remove profile
			removeProfile "$profileName"
		fi
	done < <(repoGetProfiles "$repoName")
	
	# Remove associations with ANY profile
	disablePackage "$repoName" ".*" ".*"
}

function updateRepo
{
	repoName="$1"
	
	dirName="$configDir/repos/$repoName"
	if [ ! -e "$dirName" ]; then
		echo "Repo \"$repoName\" is not currently installed." >&2
		return 1
	fi
	
	cd "$dirName"
	
	if [ ! -d .git ]; then
		echo "Repo \"$repoName\" is not a git repo." >&2
		return 1
	fi
	
	git pull
	
	cd ~-
}

function cleanRepos
{
	while read repo;do
		echo "cleanRepos Doing \"$repo\""
		installRepo_clean "$repo"
	done
}

function reInstallRepos
{
	while read repo;do
		echo "reInstallRepos: Doing \"$repo\""
		installRepo_setup "$repo"
	done
}

function updateRepos
{
	while read repo;do
		echo "updateRepos: Doing \"$repo\""
		updateRepo "$repo"
	done
}

function listRepos
{
	refine="$1"
	
	if [ "$refine" == '' ]; then
		ls -1 "$configDir"/repos
	else
		ls -1 "$configDir"/repos | grep "$refine"
	fi
}


