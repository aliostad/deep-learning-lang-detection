#!/bin/sh

export MAVEN_REPO=/Users/tryggvil/.maven/repository

java -classpath target/classes:$MAVEN_REPO/axis/jars/axis-1.3.jar:$MAVEN_REPO/axis/jars/axis-jaxrpc-1.3.jar:$MAVEN_REPO/commons-logging/jars/commons-logging-api-1.0.4.jar:$MAVEN_REPO/commons-discovery/jars/commons-discovery-0.2.jar:$MAVEN_REPO/axis/jars/axis-wsdl4j-1.5.1.jar:$MAVEN_REPO/axis/jars/axis-saaj-1.3.jar org.apache.axis.client.AdminClient -lhttp://localhost:8090/licence/services/AdminService src/java/com/idega/licence/impl/deploy.wsdd
