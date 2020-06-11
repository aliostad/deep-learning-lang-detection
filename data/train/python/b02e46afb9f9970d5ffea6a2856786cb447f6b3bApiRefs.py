
class ApiRefs(object):
    WHAT__API_INIT = "api.tas.stateControl.init"
    WHAT__API_START = "api.tas.stateControl.start"
    WHAT__API_STOP = "api.tas.stateControl.stop"
    WHAT__API_PAUSE = "api.tas.stateControl.pause"
    WHAT__API_PAUSEATEND = "api.tas.stateControl.pauseAtEnd"
    WHAT__API_TERMINATE = "api.tas.stateControl.terminate"
    WHAT__API_SIGNALSENABLE = "api.tas.signalFilter.mute.disable"
    WHAT__API_SIGNALSDISABLE = "api.tas.signalFilter.mute.ensable"
    WHAT__API_SIGNALSADD = "api.tas.signalFilter.add"
    WHAT__API_SIGNALSREMOVE = "api.tas.signalFilter.remove"
    WHAT__API_SIGNALSRETRIEVE = "api.tas.signalFilter.retrieve"
    WHAT__API_SIGNALSMUTEALL = "api.tas.signalFilter.muteAll"
    WHAT__API_SIGNALSENABLEALL = "api.tas.signalFilter.globalEnable.enable"
    WHAT__API_SIGNALSQUERY = "api.tas.signalFilter.query"
    WHAT__API_SIGNALSQUERYALL = "api.tas.signalFilter.queryAll"
    WHAT__API_SIGNALSREMOVEALL = "api.tas.signalFilter.removeAll"
    WHAT__API_TAS_STATS = "api.tas.stats"
    WHAT__API_TESTS_NEW = "api.testManagement.tests.newTests"
    WHAT__API_TESTS_STATS = "api.testManagement.tests.testStatsChange"
    WHAT__API_TESTS_STATS_REFRESH = "api.testManagement.tests.stats"
    WHAT__API_TESTS_QUERY = "api.testManagement.tests.query"
    WHAT__API_TESTS_QUERY_ALL = "api.testManagement.tests.queryAll"
    WHAT__API_TESTS_QUERY_METADATA = "api.testManagement.tests.queryMetadata"
    WHAT__API_TESTS_STATE = "api.testManagement.tests.testStateChange"
    WHAT__API_PEERS_STATS = "api.peers.peerStatsChange"
    WHAT__API_PEERS_STATS_REFRESH = "api.peers.stats"
    WHAT__API_PEERS_STATE = "api.peers.peerStateChange"
    WHAT__API_PEERS_NEW = "api.peers.newPeers"
    WHAT__API_PEERS_REMOVE = "api.peers.remove"
    WHAT__API_PEERS_QUERY = "api.peers.query"
    WHAT__API_PEERS_QUERY_ALL = "api.peers.queryAll"
    WHAT__API_TRMS_UPLOAD = "api.results.trms.upload"
    WHAT__API_PACKAGE_STATUS_CHANGE = "api.results.package.status"
    WHAT__API_RESULT_STATS = "api.results.stats"
    WHAT__API_RESULT_STATS_REFRESH = "api.results.stats.refresh"

    def getWhat(self):
        w = []
        me = dir(self)
        for i in me:
            if i.isupper() and i.startswith("WHAT"):
                w.append(i)
        return w
