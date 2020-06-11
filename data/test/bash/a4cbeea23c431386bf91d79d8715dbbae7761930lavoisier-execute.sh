#!/bin/sh
# ----------------------------------------------------------------------------
#  Copyright 2001-2006 The Apache Software Foundation.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------
#
#   Copyright (c) 2001-2006 The Apache Software Foundation.  All rights
#   reserved.


# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

PRGDIR=`dirname "$PRG"`
BASEDIR=`cd "$PRGDIR/.." >/dev/null; pwd`

# Reset the REPO variable. If you need to influence this use the environment setup file.
REPO=


# OS specific support.  $var _must_ be set to either true or false.
cygwin=false;
darwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true
           if [ -z "$JAVA_VERSION" ] ; then
             JAVA_VERSION="CurrentJDK"
           else
             echo "Using Java version: $JAVA_VERSION"
           fi
		   if [ -z "$JAVA_HOME" ]; then
		      if [ -x "/usr/libexec/java_home" ]; then
			      JAVA_HOME=`/usr/libexec/java_home`
			  else
			      JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/${JAVA_VERSION}/Home
			  fi
           fi       
           ;;
esac

if [ -z "$JAVA_HOME" ] ; then
  if [ -r /etc/gentoo-release ] ; then
    JAVA_HOME=`java-config --jre-home`
  fi
fi

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
fi

# If a specific java binary isn't specified search for the standard 'java' binary
if [ -z "$JAVACMD" ] ; then
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD="$JAVA_HOME/jre/sh/java"
    else
      JAVACMD="$JAVA_HOME/bin/java"
    fi
  else
    JAVACMD=`which java`
  fi
fi

if [ ! -x "$JAVACMD" ] ; then
  echo "Error: JAVA_HOME is not defined correctly." 1>&2
  echo "  We cannot execute $JAVACMD" 1>&2
  exit 1
fi

if [ -z "$REPO" ]
then
  REPO="$BASEDIR"/lib
fi

CLASSPATH="$BASEDIR"/etc:"$REPO"/lavoisier-service-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-engine-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-configuration-2.1.2-SNAPSHOT.jar:"$REPO"/xml-template-engine-2.1.2-SNAPSHOT.jar:"$REPO"/xml-interfaces-2.1.2-SNAPSHOT.jar:"$REPO"/xpath-functions-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-chaining-2.1.2-SNAPSHOT.jar:"$REPO"/log4j-1.2.12.jar:"$REPO"/html-template-engine-2.1.2-SNAPSHOT.jar:"$REPO"/canl-1.3.0.jar:"$REPO"/bcprov-jdk16-1.46.jar:"$REPO"/commons-io-1.4.jar:"$REPO"/lavoisier-cache-base-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-interfaces-2.1.2-SNAPSHOT.jar:"$REPO"/xpath-absolute-2.1.2-SNAPSHOT.jar:"$REPO"/dom4j-1.6.1.jar:"$REPO"/grizzly-http-server-2.2.21.jar:"$REPO"/grizzly-http-2.2.21.jar:"$REPO"/grizzly-framework-2.2.21.jar:"$REPO"/grizzly-rcm-2.2.21.jar:"$REPO"/lavoisier-cache-basex-2.1.2-SNAPSHOT.jar:"$REPO"/basex-7.9.jar:"$REPO"/lavoisier-connector-base-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-connector-cmdbuild-2.1.2-SNAPSHOT.jar:"$REPO"/cmdbuild-ws-client-2.2.0.jar:"$REPO"/cmdbuild-commons-2.2.0.jar:"$REPO"/mail-1.4.4.jar:"$REPO"/activation-1.1.jar:"$REPO"/commons-lang3-3.3.jar:"$REPO"/cxf-rt-frontend-jaxws-2.6.11.jar:"$REPO"/xml-resolver-1.2.jar:"$REPO"/asm-3.3.1.jar:"$REPO"/cxf-api-2.6.11.jar:"$REPO"/woodstox-core-asl-4.2.0.jar:"$REPO"/stax2-api-3.1.1.jar:"$REPO"/xmlschema-core-2.0.3.jar:"$REPO"/wsdl4j-1.6.3.jar:"$REPO"/cxf-rt-core-2.6.11.jar:"$REPO"/cxf-rt-bindings-soap-2.6.11.jar:"$REPO"/cxf-rt-databinding-jaxb-2.6.11.jar:"$REPO"/cxf-rt-bindings-xml-2.6.11.jar:"$REPO"/cxf-rt-frontend-simple-2.6.11.jar:"$REPO"/cxf-rt-ws-addr-2.6.11.jar:"$REPO"/cxf-rt-ws-policy-2.6.11.jar:"$REPO"/neethi-3.0.2.jar:"$REPO"/cxf-rt-ws-security-2.6.11.jar:"$REPO"/ehcache-core-2.5.1.jar:"$REPO"/wss4j-1.6.13.jar:"$REPO"/commons-logging-1.1.1.jar:"$REPO"/cxf-rt-transports-http-2.6.11.jar:"$REPO"/lavoisier-connector-config-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-connector-diff-2.1.2-SNAPSHOT.jar:"$REPO"/xmlunit-1.3.jar:"$REPO"/lavoisier-connector-grid-2.1.2-SNAPSHOT.jar:"$REPO"/saga-api-1.1.1.jar:"$REPO"/lavoisier-connector-remctl-2.1.2-SNAPSHOT.jar:"$REPO"/remctl-2.2.0.jar:"$REPO"/slf4j-api-1.6.1.jar:"$REPO"/commons-pool-1.5.6.jar:"$REPO"/lavoisier-connector-sql-2.1.2-SNAPSHOT.jar:"$REPO"/mysql-connector-java-5.1.25.jar:"$REPO"/postgresql-9.2-1003-jdbc4.jar:"$REPO"/hsqldb-2.2.9.jar:"$REPO"/xpath-parser-2.1.2-SNAPSHOT.jar:"$REPO"/jaxen-1.1.4.jar:"$REPO"/lavoisier-connector-ssh-2.1.2-SNAPSHOT.jar:"$REPO"/jsch-0.1.49.jar:"$REPO"/lavoisier-connector-telnet-2.1.2-SNAPSHOT.jar:"$REPO"/commons-net-2.0.jar:"$REPO"/lavoisier-processor-base-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-renderer-base-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-renderer-pdf-2.1.2-SNAPSHOT.jar:"$REPO"/itextpdf-5.1.3.jar:"$REPO"/xmlworker-1.1.1.jar:"$REPO"/lavoisier-serializer-base-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-serializer-html-2.1.2-SNAPSHOT.jar:"$REPO"/jtidy-r938.jar:"$REPO"/lavoisier-serializer-json-2.1.2-SNAPSHOT.jar:"$REPO"/jettison-1.3.3.jar:"$REPO"/stax-api-1.0.1.jar:"$REPO"/jackson-core-2.1.0.jar:"$REPO"/lavoisier-serializer-yaml-2.1.2-SNAPSHOT.jar:"$REPO"/jvyaml-0.2.1.jar:"$REPO"/lavoisier-serializer-ini-2.1.2-SNAPSHOT.jar:"$REPO"/ini4j-0.5.2.jar:"$REPO"/lavoisier-trigger-base-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-validator-base-2.1.2-SNAPSHOT.jar:"$REPO"/lavoisier-authenticator-base-2.1.2-SNAPSHOT.jar:"$REPO"/xml-apis-1.0.b2.jar:"$REPO"/cas-client-core-3.3.1.jar:"$REPO"/org.apache.oltu.oauth2.client-1.0.0.jar:"$REPO"/org.apache.oltu.oauth2.common-1.0.0.jar:"$REPO"/json-20131018.jar:"$REPO"/opensaml-2.6.4.jar:"$REPO"/openws-1.5.4.jar:"$REPO"/xmltooling-1.4.4.jar:"$REPO"/bcprov-jdk15on-1.51.jar:"$REPO"/not-yet-commons-ssl-0.3.9.jar:"$REPO"/commons-httpclient-3.1.jar:"$REPO"/commons-codec-1.7.jar:"$REPO"/commons-collections-3.2.1.jar:"$REPO"/commons-lang-2.6.jar:"$REPO"/velocity-1.7.jar:"$REPO"/esapi-2.0.1.jar:"$REPO"/joda-time-2.2.jar:"$REPO"/xmlsec-1.5.7.jar:"$REPO"/lavoisier-view-templates-2.1.2-SNAPSHOT.jar:"$REPO"/wrapper-3.2.3.jar:"$REPO"/lavoisier-package-2.1.2-SNAPSHOT.jar

ENDORSED_DIR=
if [ -n "$ENDORSED_DIR" ] ; then
  CLASSPATH=$BASEDIR/$ENDORSED_DIR/*:$CLASSPATH
fi

if [ -n "$CLASSPATH_PREFIX" ] ; then
  CLASSPATH=$CLASSPATH_PREFIX:$CLASSPATH
fi

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
  [ -n "$HOME" ] && HOME=`cygpath --path --windows "$HOME"`
  [ -n "$BASEDIR" ] && BASEDIR=`cygpath --path --windows "$BASEDIR"`
  [ -n "$REPO" ] && REPO=`cygpath --path --windows "$REPO"`
fi

exec "$JAVACMD" $JAVA_OPTS -Dlavoisier.configuration=lavoisier-config.xml \
  -classpath "$CLASSPATH" \
  -Dapp.name="lavoisier-execute" \
  -Dapp.pid="$$" \
  -Dapp.repo="$REPO" \
  -Dapp.home="$BASEDIR" \
  -Dbasedir="$BASEDIR" \
  fr.in2p3.lavoisier.command.Execute \
  "$@"
