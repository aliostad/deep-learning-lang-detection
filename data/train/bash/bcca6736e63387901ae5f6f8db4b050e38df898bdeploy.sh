#!/bin/bash
#echo "$#"
if [ "$#" -ne 3 ]
then
	printf "\n"
	printf "Usage: deploy.sh LocalIP TargetIP [War name]\n"
	printf "Remember to start web server from PWD before deploying with:\n"
	printf "python -m SimpleHTTPServer 8111 > /dev/null 2>&1 &\n"
	printf "\n"
	exit 1
fi
#jar -cvf $3.war . 

../twiddle.sh -s $2 invoke jboss.system:service=MainDeployer undeploy http://$1:8111/$3
../twiddle.sh -s $2 invoke jboss.system:service=MainDeployer deploy http://$1:8111/$3
../twiddle.sh -s $2 query jboss.web.deployment:*

#rm $3.war
