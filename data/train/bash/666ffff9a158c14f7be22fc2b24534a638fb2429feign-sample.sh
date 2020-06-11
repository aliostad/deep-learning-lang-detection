#!/bin/sh

PLUGIN_PATH=$FEIGN_DEV_PLUGIN_PATH/sample

echo $PLUGIN_PATH

feign \
--plugin $PLUGIN_PATH/sample/libfeign_sample.so \
--plugin $PLUGIN_PATH/sample-provider/libfeign_sample-provider.so \
--plugin $PLUGIN_PATH/sample-filter/libfeign_sample-filter.so \
--plugin $PLUGIN_PATH/sample-replayer/libfeign_sample-replayer.so \
--plugin $PLUGIN_PATH/sample-mutator/libfeign_sample-mutator.so \
--plugin $PLUGIN_PATH/sample-filter-context/libfeign_sample-filter-context.so \
--plugin $PLUGIN_PATH/sample-mutator-context/libfeign_sample-mutator-context.so \
$@

#--plugin $PLUGIN_PATH/sample-provider/libfeign_sample-provider2.so \
#--plugin $PLUGIN_PATH/sample-filter-context/libfeign_sample-filter-context2.so \
#--plugin $PLUGIN_PATH/sample-mutator-context/libfeign_sample-mutator-context2.so \
#--plugin $PLUGIN_PATH/sample-replayer/libfeign_sample-replayer2.so \
