#! /bin/bash

do_test()
{
   TECSGEN=$1
   shift
   pushd $1
   shift
   echo "##### $*  #####"
   $TECSGEN $*
   popd 
}

if [ "$1" = "" ] ; then
  echo "usage: sh test-abnormal.sh tecsgen.exe"
  exit 1
fi

do_test $1 ./sample/data-abnormal abnormal-1.idl
do_test $1 ./sample/data-abnormal abnormal-2.idl
do_test $1 ./sample/data-abnormal abnormal-3.idl
do_test $1 ./sample/data-abnormal abnormal-4.idl
do_test $1 ./sample/data-abnormal abnormal-5.idl

do_test $1 ./sample/data-error error-1.idl
do_test $1 ./sample/data-error error-2.idl
do_test $1 ./sample/data-error error-3.idl
do_test $1 ./sample/data-error error-4.idl
do_test $1 ./sample/data-error error-5.idl
do_test $1 ./sample/data-error error-6.idl
do_test $1 ./sample/data-error error-7.idl
do_test $1 ./sample/data-error error-8.idl
do_test $1 ./sample/data-error error-9.idl
do_test $1 ./sample/data-error error-10.idl
do_test $1 ./sample/data-error error-11.idl
do_test $1 ./sample/data-error error-12.idl
do_test $1 ./sample/data-error error-13.idl

