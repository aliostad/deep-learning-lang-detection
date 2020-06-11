#!/bin/sh
temp=temp
repo=${temp}/repo
exec 3<&0
while read line
do
    name=${line//@*}
    name=${name//*%}
    ver1=${line//*@}
    ver1=${ver1//*:}
    printf "==[%-18s]================================================================\n" ${name}
    [ -e ${repo}/${name}/.svn ] && (cd ${repo}/${name}; svn log -r${ver1}:head)
    [ -e ${repo}/${name}/.git ] && (cd ${repo}/${name}; git log ${ver1}.. | cat)  
    printf "==[%-18s]================================================================\n" ${name}
    read -e quit <&3
    [ "${quit}" = "q" -o "${quit}" = "quit" ] && break
done < version.txt
