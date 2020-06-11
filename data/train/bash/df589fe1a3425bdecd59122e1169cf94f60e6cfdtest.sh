for i in `ls *.spec|sed 's/shinken\-//'|sed 's/\.spec//'`
do
    SPEC_SHA1=`grep '^%global commit' shinken-$i.spec|sed 's/%global commit //'`
    #REPO_SHA1=`cat $i/.git/refs/heads/master` # master or develop for mod-webui
    REPO_SHA1=`cat $i/.git/refs/heads/*`
    if [ "$SPEC_SHA1" =  "$REPO_SHA1" ]
    then
	echo OK sha1 $i
    else
	echo KO sha1 shinken-$i.spec spec: $SPEC_SHA1 repo: $REPO_SHA1
    fi
    SPEC_JSON=`grep '^%global json_version' shinken-$i.spec|sed 's/%global json_version //'`
    REPO_JSON=`grep '"version"' $i/package.json|cut -d":" -f2|tr -d "\""|tr -d " "|tr -d ","`
    if [ "$SPEC_JSON" =  "$REPO_JSON" ]
    then
	echo OK version $i $SPEC_JSON
    else
	echo KO version $i spec: $SPEC_JSON repo: $REPO_JSON
    fi
done
