# -- for calibration from COOL
from BTagging.BTaggingFlags import BTaggingFlags
include("JetTagCalibration/BTagCalibrationBroker_Trig_jobOptions.py")
BTagCalibrationBrokerTool_Trig.folders[:] = [] # Wipe folders; these will be dynamically filled by the configuration code
from BTagging.BTaggingConfiguration import getConfiguration
ConfInst = getConfiguration("Trig")
ConfInst.registerTool("BTagCalibrationBrokerTool", BTagCalibrationBrokerTool_Trig)

# NOTE: The reason for this file is that we want to be able to set up a default configuration when requested by a Python function. However for some reason if we include JetTagCalibration/BTagCalibrationBroker_jobOptions.py at that location then the BTagCalibrationBrokerTool name will not be accessible afterwards, and we need to be able to register it. This file is included from BTaggingConfiguration_LoadTools.py.
