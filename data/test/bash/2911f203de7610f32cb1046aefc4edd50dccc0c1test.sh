#! /bin/bash

do_test()
{
   pushd $1
   shift
   echo "##### $*  #####"
   tecsgen $*
   popd 
}

do_test ./sample/data-normal normal-1.idl
do_test ./sample/data-normal normal-2.idl

do_test ./sample/data-abnormal abnormal-1.idl
do_test ./sample/data-abnormal abnormal-2.idl
do_test ./sample/data-abnormal abnormal-3.idl
do_test ./sample/data-abnormal abnormal-4.idl
do_test ./sample/data-abnormal abnormal-5.idl

do_test ./sample/data-error error-1.idl
do_test ./sample/data-error error-10.idl
do_test ./sample/data-error error-11.idl
do_test ./sample/data-error error-12.idl
do_test ./sample/data-error error-13.idl
do_test ./sample/data-error error-2.idl
do_test ./sample/data-error error-3.idl
do_test ./sample/data-error error-4.idl
do_test ./sample/data-error error-5.idl
do_test ./sample/data-error error-6.idl
do_test ./sample/data-error error-7.idl
do_test ./sample/data-error error-8.idl
do_test ./sample/data-error error-9.idl

do_test ./sample/data-flat jsp_flat.sig.CPP sample1_flat.blt.CPP sample1_flat.ct.CPP

do_test ./ test.idl
do_test ./ test2.idl
do_test ./ test_type.idl


