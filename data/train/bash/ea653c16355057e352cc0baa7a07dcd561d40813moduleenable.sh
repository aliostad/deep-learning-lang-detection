#!/bin/bash
sed -i 's^<!-- <load module="mod_curl"/> -->^<load module="mod_curl"/>^g' /usr/local/src/xml/modules.conf.xml;
sed -i 's^<!-- <load module="mod_spy"/> -->^<load module="mod_spy"/>^g' /usr/local/src/xml/modules.conf.xml;
sed -i 's^<!-- <load module="mod_opus"/> -->^<load module="mod_opus"/>^g' /usr/local/src/xml/modules.conf.xml;
sed -i 's^<!-- <load module="mod_skinny"/> -->^<load module="mod_skinny"/>^g' /usr/local/src/xml/modules.conf.xml;
sed -i 's^<!-- <load module="mod_cdr_sqlite"/> -->^<load module="mod_cdr_sqlite"/>^g' /usr/local/src/xml/modules.conf.xml;
sed -i 's^<!-- <load module="mod_shout"/> -->^<load module="mod_shout"/>^g' /usr/local/src/xml/modules.conf.xml;
sed -i 's^<!-- <load module="mod_syslog"/> -->^<load module="mod_syslog"/>^g' /usr/local/src/xml/modules.conf.xml;
sed -i 's^<!-- <load module="mod_xml_rpc"/> -->^<load module="mod_xml_rpc"/>^g' /usr/local/src/xml/modules.conf.xml;
sed -i 's^<!-- <load module="mod_xml_curl"/> -->^<load module="mod_xml_curl"/>^g' /usr/local/src/xml/modules.conf.xml;
sed -i 's^<!-- <load module="mod_xml_cdr"/> -->^<load module="mod_xml_cdr"/>^g' /usr/local/src/xml/modules.conf.xml;
sed -i 's^<!-- <load module="mod_xml_scgi"/> -->^<load module="mod_xml_scgi"/>^g' /usr/local/src/xml/modules.conf.xml;
cp /usr/local/src/xml/modules.conf.xml /usr/local/freeswitch/conf/autoload_configs/;
