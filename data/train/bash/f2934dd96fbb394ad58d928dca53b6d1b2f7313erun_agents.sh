#! /bin/bash

. functions.sh

processArgs $*

makeClasspath $BASEDIR/lib $BASEDIR/jars

#java -Xmx1024m -cp $CP rescuecore2.LaunchComponents sample.SampleFireBrigade*n sample.SampleAmbulanceTeam*n sample.SamplePoliceForce*n sample.SampleCentre*n -c $DIR/config/sample-agents.cfg 2>&1 | tee $LOGDIR/sample-out.log
java -Xmx1024m -cp $CP rescuecore2.LaunchComponents sample.SampleFireBrigade*n sample.SampleAmbulanceTeam*n sample.SamplePoliceForce*n sample.SampleCentre*n sample.SampleCivilian*n -c $DIR/config/sample-agents.cfg 2>&1 | tee $LOGDIR/sample-out.log
#java -Xms256m -cp $CP rescuecore2.LaunchComponents sample.SampleFireBrigade*n sample.SampleAmbulanceTeam*n sample.SamplePoliceForce*n sample.SampleCentre*n sample.SampleCivilian*n -c $DIR/config/sample-agents.cfg 2>&1 | tee $LOGDIR/sample-out.log
