
from epyrpc.api.ApiFactory import ApiFactory
from epyrpc.api.ApiParamError import ApiParamError
from epyrpc.api.UnknownApiError import UnknownApiError
from epyrpc.api.eApiType import eApiType
from epyrpc.api.iApi import iApi
from epyrpc.utils.configuration.ConfigurationManager import ConfigurationManager
import os
import unittest

class TestApiFactory(unittest.TestCase):
    def setUp(self):
        print "cwd: ", os.getcwd()
        path = os.path.realpath("config/ipc")
        ConfigurationManager(cwd=path)
        self.apis = []
    def tearDown(self):
        ConfigurationManager.destroySingleton()
        for api in self.apis:
            try:    api.teardown()
            except: pass
    def testValid(self):
        t = eApiType.EO_V1
        assert eApiType.isValid(t)
        api_ = ApiFactory.get(t)
        self.apis.append(api_)
        assert isinstance(api_, iApi)
        t = eApiType.EO_V1__HANDLER
        assert eApiType.isValid(t)
        api_ = ApiFactory.get(t)
        self.apis.append(api_)
        assert isinstance(api_, iApi)
    def testInvalidType(self):
        t = eApiType.EO_V1 + "hello.world!"
        assert not eApiType.isValid(t)
        try:
            ApiFactory.get(t)
        except ApiParamError, e:
            assert e.item == t
            assert eApiType in e.allowedTypes
            assert len(e.allowedTypes) == 1
        else:
            assert False
    def testUnsupported(self):
        t = eApiType.UNSUPPORTED
        try:
            ApiFactory.get(t)
        except UnknownApiError, _e:
            assert True
        else:
            assert False

if __name__ == '__main__':
    unittest.main()
