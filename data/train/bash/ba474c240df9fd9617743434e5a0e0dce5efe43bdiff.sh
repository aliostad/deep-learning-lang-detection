#!/bin/bash
Repo=${1%/}
before=${2%/}
patched=${3%/}
if [ "$#" -ne 3 ]
then
  echo "Please pass parameters for valid Patch directory, eg. OpenPetraPatchSomething before patched"
  exit 1
fi
if [ -d $Repo/patch ]
then
  mv $Repo/patch $Repo/patchOld
fi
mkdir -p $Repo/patch
filename=
# make sure that diff shows english messages
export LC_ALL=C
while read line; do
  if [[ "${line:0:9}" == "diff -uNr" ]]
  then
    #echo $line
    splitBySpace=( $line )
    len="${#splitBySpace[@]}"
    path=${splitBySpace[$len-1]}
    if [[ "${path:(-5)}" != ".orig" ]]
    then 
      #remove patched/ from path
      strlen=${#patched}
      path=${path:$strlen+1}
      filename=$path
      mkdir -p `dirname $Repo/patch/$filename`
      diff -uNr $before/$path $patched/$path > $Repo/patch/$filename.patch
      if [ ! -f $patched/$path ]
      then
        # file was deleted
        rm -f $Repo/patch/$filename.patch
        if [ -f $Repo/patchOld/$filename.delete ]
        then
          mv $Repo/patchOld/$filename.delete $Repo/patch/$filename.delete
        else
          echo "removing $path"
          touch $Repo/patch/$filename.delete
        fi
      elif [ ! -f $before/$path ]
      then
        # file was added
        rm -f $Repo/patch/$filename.patch
        if [ -f $Repo/patchOld/$filename.add ] && [ `diff $Repo/patchOld/$filename.add $patched/$path | wc -l` -eq 0 ]
        then
          mv $Repo/patchOld/$filename.add $Repo/patch/$filename.add
        else
          echo "adding $path"
          cp $patched/$path $Repo/patch/$filename.add
        fi
      elif [ -f $Repo/patchOld/$filename.patch ]
      then
         linesDifferent=`diff $Repo/patch/$filename.patch $Repo/patchOld/$filename.patch | wc -l`
         if [ $linesDifferent -eq 6 -o $linesDifferent -eq 0 ]
         then
           mv $Repo/patchOld/$filename.patch $Repo/patch/$filename.patch
         else
           echo "patching " $filename
         fi
      else
        echo "patching " $filename
      fi
    fi
  elif [[ "${line:0:12}" == "Binary files" ]]
  then
    splitBySpace=( $line )
    len="${#splitBySpace[@]}"
    path=${splitBySpace[$len-2]}
    #remove patched/ from path
    strlen=${#patched}
    filename=${path:$strlen+1}
    mkdir -p `dirname $Repo/patch/$filename`
    if [ -f $path ]
    then
      cp $path $Repo/patch/$filename.binary
      if [ -f $Repo/patchOld/$filename.binary ]
      then
        linesDifferent=`diff $Repo/patch/$filename.binary $Repo/patchOld/$filename.binary | wc -l`
        if [ $linesDifferent -eq 6 -o $linesDifferent -eq 0 ]
        then
          mv $Repo/patchOld/$filename.binary $Repo/patch/$filename.binary
        else
          echo $filename.binary
        fi
      else
        echo $filename.binary
      fi 
    elif [ -f $Repo/patchOld/$filename.delete ]
    then
      mv $Repo/patchOld/$filename.delete $Repo/patch/$filename.delete
    else
      echo "removing $path"
      touch $Repo/patch/$filename.delete
    fi
  fi
done < <(diff -uNr -x .bzr -x .git $before $patched | grep -E "Binary files|diff -uNr")
rm -Rf $Repo/patchOld
