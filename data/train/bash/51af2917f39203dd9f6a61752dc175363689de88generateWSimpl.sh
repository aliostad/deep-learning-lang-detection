export MAVEN_REPO=$HOME/.maven/repository

java -classpath target/classes:$MAVEN_REPO/axis/jars/axis-1.3.jar:$MAVEN_REPO/axis/jars/axis-jaxrpc-1.3.jar:$MAVEN_REPO/commons-logging/jars/commons-logging-1.0.4.jar:$MAVEN_REPO/commons-discovery/jars/commons-discovery-0.2.jar:$MAVEN_REPO/axis/jars/axis-wsdl4j-1.5.1.jar:$MAVEN_REPO/axis/jars/axis-saaj-1.3.jar org.apache.axis.wsdl.WSDL2Java -s -p is.idega.idegaweb.egov.accounting.wsimpl -o src/java src/java/is/idega/idegaweb/egov/accounting/ws/AccountingService.wsdl


The maritech navision webservice
java -classpath target/classes:$MAVEN_REPO/axis/jars/axis-1.3.jar:$MAVEN_REPO/axis/jars/axis-jaxrpc-1.3.jar:$MAVEN_REPO/commons-logging/jars/commons-logging-1.0.4.jar:$MAVEN_REPO/commons-discovery/jars/commons-discovery-0.2.jar:$MAVEN_REPO/axis/jars/axis-wsdl4j-1.5.1.jar:$MAVEN_REPO/axis/jars/axis-saaj-1.3.jar org.apache.axis.wsdl.WSDL2Java -s -p is.idega.idegaweb.egov.accounting.wsimpl -o src/java src/java/is/idega/idegaweb/egov/accounting/ws/MaritechNavision.wsdl

