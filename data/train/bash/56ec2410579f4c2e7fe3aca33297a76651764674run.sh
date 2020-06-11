#! /bin/bash

ACN="./sample/SampleAcn.java"
MODULE="./sample/module/SampleLoginModule.java"
PRINCIPAL="./sample/principal/SamplePrincipal.java"
config="./sample_jaas.config.txt"
data="./sample/db/data.txt"

if [ -f $ACN ] && 
    [ -f $MODULE ] && 
    [ -f $PRINCIPAL ] &&
    [ -f $config ] &&
    [ -f $data ]
then
    echo "Compiling ... "
    javac $ACN $MODULE $PRINCIPAL
    echo "Launching ... "
    java -Djava.security.auth.login.config==$config sample.SampleAcn
    echo "Cleaning ... "
    find . -name *.class -delete
    rm sample/db/tmp.txt
else
    echo "One or more required files do not exist"
fi