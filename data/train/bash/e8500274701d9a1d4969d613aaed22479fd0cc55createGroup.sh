#!/bin/bash

#
# Creates a Nexus Repository Group via REST API.
#

generateGroupXml() {

   if [ $# -lt 2 ]
   then
      echo "generateGroupXml(): must provide at least two args:  groupName, repo1[, ...]" 1>&2
      return 1
   fi

   repoGroupTmpDir=/tmp

   groupName=$1
   shift 1
   repos=$*

   rm -f ${repoGroupTmpDir}/*repo-group-member-*

   for repo in $repos
   do

   if ! repoGroupMemberTemp=$(mktemp --tmpdir=${repoGroupTmpDir} --suffix=repo-group-member-${repo})
   then
      echo "unable to execute mktemp --tmpdir=${repoGroupTmpDir} --suffix=repo-group-member-${repo}" 1>&2
      return 1
   fi

   cat >${repoGroupMemberTemp}  <<!
      <repo-group-member>
        <id>${repo}</id>
        <name>${repo}</name>
        <resourceURI>${nexusUrl}/service/local/repo_groups/${groupName}/${repo}</resourceURI>
      </repo-group-member>
!
   done

   cat <<!
<repo-group>
  <data>
    <id>${groupName}</id>
    <name>${groupName}</name>
    <provider>maven2</provider>
    <format>maven2</format>
    <repoType>group</repoType>
    <exposed>true</exposed>
    <repositories>
!
   cat ${repoGroupTmpDir}/*repo-group-member-*
   cat <<!
    </repositories>
  </data>
</repo-group>
!

   rm -f ${repoGroupTmpDir}/*repo-group-member-* > /dev/null 2>&1

}

if [ $# -lt 5 ]
then
   echo "createGroup: must provide at least five args:  nexusUrl, username, password, groupName, repo1, [repo2], ...." 1>&2
   echo "example:"
   echo "createGroup.sh  https://$(hostname)/nexus admin admin123 sdp-public-snapshots sdp-snapshots"  
   exit 1
fi

nexusUrl=$1
username=$2
password=$3
groupName=$4
shift 4
repos=$*


tmpGroupXml=$(mktemp)

if ! generateGroupXml $groupName $repos > ${tmpGroupXml}
then
   exit 1
fi

curl  -s -I    -k  -H "Content-Type: application/xml"  -X GET   -u ${username}:${password} ${nexusUrl}/service/local/repo_groups/${groupName} | grep -q '^HTTP/1.1.* 404'
if [ $? -ne 0 ]
then
    echo "it appears that repository group ${groupName} already exists"
    exit 0
fi

if ! curl  -s -k  -H "Accept: application/xml" -H "Content-Type: application/xml" -f -X POST  -d "@${tmpGroupXml}" -u ${username}:${password} ${nexusUrl}/service/local/repo_groups > /dev/null
then
   echo "unable to create group ${groupName}" 1>&2
   exit 1
fi

rm -f ${tmpGroupXml}
echo "created group: ${groupName}"
exit 0
