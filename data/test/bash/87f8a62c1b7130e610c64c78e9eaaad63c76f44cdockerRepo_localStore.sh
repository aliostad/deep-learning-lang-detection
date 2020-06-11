REPOS="postgres node nginx"
STOREDIR="/tmp/dockerRepos"
for REPO in $REPOS
do
        #echo "Verifying $REPO, this might take a few minutes"
        [[ -e ${STOREDIR}/${REPO}.tar ]] && {
                sudo docker images | egrep -q "^$REPO" || sudo docker load -i ${STOREDIR}/${REPO}.tar || exit 1
        } || {
                sudo docker images | egrep -q "^$REPO" || sudo docker pull ${REPO}:latest
                #echo "archiving $REPO, this might take a few minutes"
                [[ -e ${STOREDIR}/$(dirname $REPO) ]] || mkdir ${STOREDIR}/$(dirname $REPO)
                sudo docker save -o ${STOREDIR}/${REPO}.tar $REPO
        }
done
