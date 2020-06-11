
SAMPLES=" \
  GEVPlayerSample \
  PvDeviceFindingSample \
  PvGenParameterArraySample \
  PvPipelineSample \
  PvMulticastMasterSample \
  PvMulticastSlaveSample \
  PvRGBFilterSample \
  PvBufferWriterSample \
  PvConfigurationReaderSample \
  PvStreamSample \
  PvSerialPortIPEngineSample \
  PvTransmitTestPatternSample \
  PvTransmitRawSample \
  PvReceiveRawSample \
  PvTransmitVideoSample \
  PvTransformAndTransmitSample \
  PvDualSourceSample \
  PvMultiSourceSample \
"

for SAMPLE in $SAMPLES; do
  make -C $SAMPLE
done

