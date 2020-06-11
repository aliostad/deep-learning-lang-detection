# Get a repo
# Install/update a repo

function addRepo
{
	repoSrc="$1"
	dstName="$2"
	
	echo "addRepo: \"$repoSrc\" -> \"$dstName\""
	
	if [ "`echo $repoSrc | grep '\(@\|://\)'`" != '' ]; then
		getRepo "$dstName" "$repoSrc"
	else
		addPretendRepo "$repoSrc" "$dstName"
	fi
}

function getRepo
{
	repoName="$1" # What we are going to refer to it as once it's installed.
	repoSrc="$2" # Where to get it from. This is likely to be a git URL.
	reposDir="$configDir/repos"
	repoDir="$reposDir/$repoName"
	
	if [ -d "$repoDir"  ]; then
		cd "$repoDir"
		git pull
	else
		mkdir -p "$reposDir"
		git clone "$repoSrc" "$repoDir"
	fi
}

function addPretendRepo
{
	# This is specifically for the rare situation where you need to link in an 
	# existing folder structure as if it was a cloned repo.
	# 
	# The only situation I can think of where it is valid to use this is if you
	# are developing that repo.
	
	# Sort out what we are working with.
	fullSrcPath="$1"
	name=`echo "$fullSrcPath" | sed 's#/$##;
		s#.*/##g'`
	if [ "$2" != "" ]; then
		dstName="$2"
	else
		dstName="$name"
	fi

	# Prep
	mkdir /tmp/$$
	cd /tmp/$$

	# Get the link
	ln -s "$fullSrcPath" .
	if [ "$name" != "$dstName" ]; then
		mv "$name" "$dstName"
	fi 

	# Pre clean
	cd "$configDir"/repos
	if [ -f "$dstName" ]; then
		rm "$dstName"
	elif [ -d "$dstName" ]; then
		rm -Rf "$dstName"
	elif [ -L "$dstName" ]; then
		rm "$dstName"
	fi


	# Put it in place
	mv "/tmp/$$/$dstName" .

	# Clean up
	rm -Rf /tmp/$$
}

function removeRepo
{
	repoName="$1"
	repoDir="$configDir/repos/$repoName"
	
	documentationRemoveRepo "$repoName"
	
	if [ ! -e "$repoDir" ]; then
		echo "Could not find repo \"$repoName\". You can list them using repoList."
		exit 1
	fi

	if [ -h "$repoDir" ]; then # Symlink (pretend repo)
		rm "$repoDir"
	elif [ -d "$repoDir" ]; then # Directory
		rm -Rf "$repoDir"
	fi
}

function repoExists
{
	name="$1"
	if [ -e "$configDir/repos/$name" ]; then
		return 0
	else
		return 1
	fi
}

function renameRepo
{
	fromName="$1"
	toName="$2"
	
	if [ ! -e "$configDir/repos/$fromName" ]; then
		echo "renameRepo: source repo \"$fromName\" does not exist." >&2
		return 1
	fi
	
	if [ -e "$configDir/repos/$toName" ]; then
		echo "renameRepo: destination repo \"$toName\" already exists." >&2
		return 1
	fi
	
	mv "$configDir/repos/$fromName" "$configDir/repos/$toName"
}

function findRepo
{
	repoSearchTerm="$1"
	
	if repoExists "$repoSearchTerm"; then
		echo "$repoSearchTerm"
		return 0
	else
		repos="`resolveSymlinks \"$configDir\"/repos | grep \"$repoSearchTerm\"`"
		echo "$repos" | cut -d\	 -f 1
		if [ `echo "$repos" | wc -l` == '1' ]; then
			return 0
		else
			return 1
		fi
	fi
}

function formatRepoResults
{
	while read in;do
		echo "$in" | tabsToSpacedDashes
		name=`echo "$in" | cut -d\	 -f1`
		repoGetParms "$name"
		echo
	done
}