export MAVEN_REPO=/Users/tryggvil/.maven/repository

java -classpath target/classes:$MAVEN_REPO/axis/jars/axis-1.3.jar:$MAVEN_REPO/axis/jars/axis-jaxrpc-1.3.jar:$MAVEN_REPO/commons-logging/jars/commons-logging-api-1.0.4.jar:$MAVEN_REPO/commons-discovery/jars/commons-discovery-0.2.jar:$MAVEN_REPO/axis/jars/axis-wsdl4j-1.5.1.jar:$MAVEN_REPO/axis/jars/axis-saaj-1.3.jar org.apache.axis.wsdl.WSDL2Java -o src/java src/xsd/Fasteignaskra.xsd
#java -jar $MAVEN_REPO/com.sun.xml.bind/jars/jaxb-xjc-2.0.1.jar -classpath $MAVEN_REPO/com.sun.xml.bind/jars/jaxb-impl-2.0.1.jar -o src/java src/xsd/Fasteignaskra.xsd
