#!/bin/bash

for i in `ldapsearch -x -LLL -h lcg-bdii:2170 -b o=grid '(&(objectClass=GlueSA)(GlueSAAccessControlBaseRule=*dteam*))' GlueChunkKey | grep GlueChunkKey: | cut -d":" -f2`; do

          ldapsearch -x -LLL -h lcg-bdii:2170 -b o=grid "(&(|(objectClass=GlueSEAccessProtocol)(objectClass=GlueSEControlProtocol))(GlueChunkKey=$i))" GlueSEAccessProtocolEndpoint | grep GlueSEAccessProtocolEndpoint: | cut -d":" -f2- > endpoints

          ldapsearch -x -LLL -h lcg-bdii:2170 -b o=grid "(&(objectClass=GlueSEControlProtocol)(GlueChunkKey=$i))" GlueSEControlProtocolEndpoint | grep GlueSEControlProtocolEndpoint: | cut -d":" -f2- >> endpoints

          ldapsearch -x -LLL -h lcg-bdii:2170 -b o=grid "(&(objectClass=GlueVOInfo)(GlueVOInfoAccessControlBaseRule=*dteam*)(GlueChunkKey=$i))" GlueVOInfoPath | grep GlueVOInfoPath: | cut -d":" -f2 > path

          for path in `cat path`; do
              for endpoint in `cat endpoints`; do
                  echo $endpoint?SFN=$path                
              done
          done
done

