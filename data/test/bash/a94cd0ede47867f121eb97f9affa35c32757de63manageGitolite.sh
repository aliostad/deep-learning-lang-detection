source ../functions/file_functions.sh

function createRepo() {
	REPO_NAME=$1
	CONF_FILE_PATH=$2

	repoLineNo=`getLineNoMatchingRegex $CONF_FILE_PATH "repo ${REPO_NAME}"`
	if [ -z "${repoLineNo}" ]; then
		echo "Creating repo ${REPO_NAME} in conf file ${CONF_FILE_PATH}"

		echo "@${REPO_NAME}_ReadAccessGroup=" >>  ${CONF_FILE_PATH}
		echo "@${REPO_NAME}_ReadWriteAccessGroup=" >>  ${CONF_FILE_PATH}
		echo "repo ${REPO_NAME}" >>  ${CONF_FILE_PATH}
		echo "RW+=@${REPO_NAME}_ReadAccessGroup"  >>  ${CONF_FILE_PATH}
		echo "RW+=@${REPO_NAME}_ReadWriteAccessGroup"  >>  ${CONF_FILE_PATH}
		
	else
		echo "Repo ${REPO_NAME} already exists in conf file ${CONF_FILE_PATH}"             
        fi
	
}

function deleteRepo() {
        REPO_NAME=$1
        CONF_FILE_PATH=$2	

	repoLineNo=`getLineNoMatchingRegex $CONF_FILE_PATH "@${REPO_NAME}_ReadAccessGroup="`
	
	#Validation if repo exists or not
	if [ -n "${repoLineNo}" ]; then
		echo "Deleting repo ${REPO_NAME} from conf file ${CONF_FILE_PATH}"
		deleteLinesFromFile ${repoLineNo} 5 ${CONF_FILE_PATH}
#		deleteLineFromFile ${repoLineNo} ${CONF_FILE_PATH}
#		deleteLineFromFile ${repoLineNo} ${CONF_FILE_PATH}
#                deleteLineFromFile ${repoLineNo} ${CONF_FILE_PATH}
#                deleteLineFromFile ${repoLineNo} ${CONF_FILE_PATH}
	else
		 echo "Repo ${REPO_NAME} doesn't exist in conf file ${CONF_FILE_PATH}"		
	fi
}

function grantAccessToUser() {
        REPO_NAME=$1        
        CONF_FILE_PATH=$2
	USER_NAME=$3

	repoLineNo=`getLineNoMatchingRegex $CONF_FILE_PATH "repo ${REPO_NAME}"`

	if [ -n "${repoLineNo}" ]; then
		echo "Giving access to ${USER_NAME} on repo ${REPO_NAME} in conf file ${CONF_FILE_PATH}"
	else
		echo "Repo ${REPO_NAME} doesn't exist in conf file ${CONF_FILE_PATH}"             
        fi
}
