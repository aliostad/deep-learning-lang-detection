#!/bin/bash

# source codes
action="./sample/SampleAction.java"
azn="./sample/SampleAzn.java"
logmod="./sample/module/SampleLoginModule.java"
principal="./sample/principal/SamplePrincipal.java"

# security data and init
policy="./sampleazn.policy"
config="sample_jaas.config"

# static data for auth and subscriptions
pass="./sample/db/data.txt"
subscriptions="./sample/db/subscriptions.txt"

# class data generted by compile
aznclass="./sample/SampleAzn.class"
callbackclass="./sample/MyCallbackHandler.class"
actionclass="./sample/SampleAction.class"
moduleclass="./sample/module/SampleLoginModule.class"
princclass="./sample/principal/SamplePrincipal.class"

# cleaning function
function clean(){
    echo "Cleaning ..."
    find . -name "*.jar" -delete &> /dev/null
    find . -name "*.class" -delete &> /dev/null
    rm ./sample/db/tmp.txt &> /dev/null
}

if [ ! -e $(which javac) ] ||
    [ ! -e $(which jar) ] ||
    [ ! -e $(which java) ]; then
    ehco "One ore more executable ( javac, jar, java ) are missing ..."
    exit
else 
    if [ ! -f $action ] ||
	[ ! -f $azn ] ||
	[ ! -f $logmod ] ||
	[ ! -f $principal ] ||
	[ \( ! -f $pass \) -o \( ! -f $subscriptions \) ]; then
    echo "One or more file needed to compile are missing ..."
    exit
    else
	echo "Compiling ... "
	javac $action $azn $logmod $principal &> /dev/null # creates class bytecode
	echo "Generating jars ..."
	jar -cvf SampleAzn.jar $aznclass $callbackclass &> /dev/null # generates jar
	jar -cvf SampleAction.jar $actionclass &> /dev/null
	jar -cvf SampleLM.jar $moduleclass $princclass &> /dev/null
	echo "Launching ..."
	java -classpath SampleAzn.jar:SampleAction.jar:SampleLM.jar -Djava.security.manager -Djava.security.policy=$policy -Djava.security.auth.login.config==$config sample.SampleAzn
    fi
fi

status=$?
clean
echo "Program exited with status $status"
