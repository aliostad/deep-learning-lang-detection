echo -e "\e[1mCreate a new Repo\e[0m"
echo -e "\e[32;1mPlease input the Name of Repo\e[0m"
echo -e "\e[32;1mValid charaters: _0-9A-Za-z, start with A-Za-z\e[0m"

read InputRepoName

# Judge if InputRepoName valid
if [[ -z ${InputRepoName} ]]
then
	echo -e "\e[31;1m[Error]Repo's name is empty\e[0m"
	exit
fi
if ! echo "${InputRepoName}" | grep -q -P '^[_a-zA-Z][_a-zA-Z0-9]*$'
then
	echo -e "\e[31;1m[Error]Repo name inputed contains illegal charaters\e[0m"
	exit
fi

# Judge if RepoName already exist
for RepoName in /home/svn/repositories/*
do
	if [[ ${RepoName} == '/home/svn/repositories/*' ]]
	then
		echo -e "\e[35;1m[Warn]There's no Repositories in this server\e[0m"
		echo -e "\e[35;1m[SEVERE]Please check or contact shiraihii\e[0m"
		exit
	fi
	PureRepoName=`echo "${RepoName}" | grep -P -o '[_a-zA-Z][_a-zA-Z0-9]*$'`
	if [[ ${PureRepoName} == ${InputRepoName} ]]
	then
		echo -e "\e[35;1m[Error]Repo ${PureRepoName} already exists!\e[0m"
		exit
	fi
done

# Create Repo
svnadmin create "/home/svn/repositories/${InputRepoName}"
chown -R http.http "/home/svn/repositories/${InputRepoName}"

# Create policy and last file
sudo -u http touch "/home/svn/repositories/${InputRepoName}/conf/apacheauth"
sudo -u http echo 0 > "/home/svn/repositories/${InputRepoName}/db/last"
sudo -u http echo 0 > "/home/svn/repositories/${InputRepoName}/db/cronlast"

# Done
echo -e "\e[33;1mDone\e[0m"
