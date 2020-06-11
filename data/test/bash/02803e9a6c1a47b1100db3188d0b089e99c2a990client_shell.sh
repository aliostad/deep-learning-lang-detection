repo=${PWD##*/}
vm_name="$HOSTNAME"
case $1 in 
	poke) curl --GET "http://richaj.housing.com:3002/api/clients/$1?sender=$HOSTNAME&reciever=$2&message=$3"
	;;
	openpr) curl --GET "http://richaj.housing.com:3002/api/clients/$1?repo=$repo&git_username=$2&title=$3&head=$4&base=$5"
	;;
	createissue) curl --GET "http://richaj.housing.com:3002/api/clients/$1?repo=$repo&git_username=$2&title=$3&body=$4"
	;;
	pending) curl --GET 'http://richaj.housing.com:3002/api/clients/pending?name='$vm_name'&repo_name='$2
	;;
	listissues) curl --GET "http://richaj.housing.com:3002/api/clients/listissues?repo=$repo&git_username=$2"
	;;
	listissuecomments) curl --GET "http://richaj.housing.com:3002/api/clients/listissuecomments?repo=$repo&git_username=$2&issue_id=$3"
	;;
	listprcomments) curl --GET "http://richaj.housing.com:3002/api/clients/listprcomments?repo=$repo&git_username=$2&issue_id=$3"
	;;
	createissuecomment) curl --GET "http://richaj.housing.com:3002/api/clients/createissuecomment?repo=$repo&git_username=$2&issue_id=$3&body=$4"
	;;
	top_penders) curl --GET "http://richaj.housing.com:3002/api/clients/top_pender"
	;;
	*) ERR_MSG="Please enter a valid option!"
		 echo $ERR_MSG
	;;
esac
