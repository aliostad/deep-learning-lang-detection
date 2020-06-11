#!/bin/bash

node_modules/.bin/pbjs StringSerialisation.proto -s proto -t json -m -o /tmp/StringSerialisation.json -q 
cat /tmp/StringSerialisation.json | awk '{print "var stringSerialisationJson = "$0";"}' > static-content/StringSerialisation.js

node_modules/.bin/pbjs IntermediateModel.proto -s proto -t json -m -o /tmp/rawIntermediateModel.json -q
cat /tmp/rawIntermediateModel.json | awk '{print "var rawIntermediateModelJson = "$0";"}' > static-content/rawIntermediateModel.js

cat IntermediateModel.proto | sed -e 's/optional string/repeated int32/g' > /tmp/IntermediateModel.proto
cat /tmp/IntermediateModel.proto | sed -e 's/required string/repeated int32/g' > /tmp/IntermediateModel.proto2
cat /tmp/IntermediateModel.proto2 | sed -e 's/ *\[ *default.*\;$/\;/' > /tmp/IntermediateModel.proto
cp StringSerialisation.proto /tmp
node_modules/.bin/pbjs /tmp/IntermediateModel.proto -s proto -t json -m -o /tmp/IntermediateModel.json -q 
cat /tmp/IntermediateModel.json | awk '{print "var intermediateModelJson = "$0";"}' > static-content/IntermediateModel.js


