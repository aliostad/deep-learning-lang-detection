#!/bin/bash

#
# Creates a Nexus Repository via REST API.
#

generateRepoXml() {
   repoName=$1
   repoPolicy=$2
   writePolicy=$3

   if [ $# -ne 3 ]
   then
      echo "generateRepoXml(): must provide three args:  repoName, repoPolicy, writePolicy" 1>&2
      return 1
   fi

   case $repoPolicy in
      "RELEASE")
         ;;
      "SNAPSHOT")
         ;;
      *)
         echo "generateRepoXml(): repoPolicy must be RELEASE or SNAPSHOT" 1>&2
         return 1
    esac

   case $writePolicy in
      "ALLOW_WRITE")
         ;;
      "ALLOW_WRITE_ONCE")
         ;;
      *)
         echo "generateRepoXml(): writePolicy must be ALLOW_WRITE or ALLOW_WRITE_ONCE" 1>&2
         return 1
    esac

   cat <<!
<?xml version="1.0" encoding="UTF-8"?>

<repository>
 <data>
   <id>${repoName}</id>
   <name>${repoName}</name>
   <provider>maven2</provider>
   <repoType>hosted</repoType>
   <providerRole>org.sonatype.nexus.proxy.repository.Repository</providerRole>
   <contentResourceURI>https://mcollective-centos62-64-m1.local/nexus/content/repositories/${repoName}</contentResourceURI>
   <format>maven2</format>
   <exposed>true</exposed>
   <writePolicy>${writePolicy}</writePolicy>
   <browseable>true</browseable>
   <indexable>true</indexable>
   <notFoundCacheTTL>1440</notFoundCacheTTL>
   <repoPolicy>${repoPolicy}</repoPolicy>
   <downloadRemoteIndexes>false</downloadRemoteIndexes>
   <defaultLocalStorageUrl>file:/var/lib/nexus/nexus-professional-2.0.6/./../sonatype-work/nexus/storage/${repoName}/</defaultLocalStorageUrl>
 </data>
</repository>
!

}

if [ $# -ne 6 ]
then
   echo "createRepo: must provide six args:  repoName, repoPolicy (RELEASE|SNAPSHOT), writePolicy (ALLOW_WRITE|ALLOW_WRITE_ONCE), baseUrl, username, password" 1>&2
   echo "example:"
   echo "createRepo.sh  myrepo-releases RELEASE  ALLOW_WRITE_ONCE https://$(hostname)/nexus admin admin123" 
   exit 1
fi

repoName=$1
repoPolicy=$2
writePolicy=$3
nexusUrl=$4
username=$5
password=$6

tmpRepoXml=$(mktemp)

if ! generateRepoXml $repoName $repoPolicy $writePolicy > ${tmpRepoXml}
then
   exit 1
fi

curl  -s -I    -k  -H "Content-Type: application/xml"  -X GET   -u ${username}:${password} ${nexusUrl}/service/local/repositories/${repoName} | grep -q '^HTTP/1.1.* 404' 
if [ $? -ne 0 ]
then
    echo "it appears that repository ${repoName} already exists"
    exit 0
fi

if ! curl  -s -k  -H "Accept: application/xml" -H "Content-Type: application/xml" -f -X POST  -d "@${tmpRepoXml}" -u ${username}:${password} ${nexusUrl}/service/local/repositories > /dev/null
then
   echo "unable to create repository ${repoName}" 1>&2
   exit 1
fi
rm -f ${tmpRepoXml}
echo "created repository: ${repoName}"
exit 0
