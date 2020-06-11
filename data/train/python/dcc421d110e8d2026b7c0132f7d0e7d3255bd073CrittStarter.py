import xml.etree.ElementTree as ElementTree

from subprocess import Popen

# TODO: Discuss about the SCM side of the project.
# TODO: Discuss about the code review and quality.

# TODO: Secure it.
# TODO: Error codes!
class Crittstarter(object):
    def __init__(self):
        self.mTree = ElementTree.parse('CrittWorkPlan.xml')
        self.mRoot = self.mTree.getroot()

        self.mSettings = {}
        self.mCrittBrokerData = {}
        self.mCritterData = {}

    def start(self):
        self.__getSettings()
        self.__readCrittBrokers()
        self.__readCritters()
        self.__startCrittBrokers()
        self.__startCritters()

    def __getSettings(self):
        settings = self.mRoot.find('settings')
        self.mSettings['username'] = settings.find('username').text
        self.mSettings['workingDirectory'] = settings.find('workingDirectory').text
        self.mSettings['heartbeat'] = settings.find('heartbeat').text
        self.mSettings['maxDelay'] = settings.find('maxDelay').text

        self.mCrittBrokerData = {}

    def __readCrittBrokers(self):
        crittBrokers = self.mRoot.find('infrastructure').find('crittBrokers')

        for crittBroker in crittBrokers:
            name = crittBroker.find('name').text
            self.mCrittBrokerData[name] = {}
            self.mCrittBrokerData[name]['name'] = crittBroker.find('name').text
            self.mCrittBrokerData[name]['host'] = crittBroker.find('host').text
            # TODO: Auto-vivification.
            self.mCrittBrokerData[name]['connections'] = {}
            self.mCrittBrokerData[name]['connections']['publish'] = {}
            self.mCrittBrokerData[name]['connections']['subscribe'] = {}
            self.mCrittBrokerData[name]['connections']['ui'] = {}
            self.mCrittBrokerData[name]['connections']['brokerPublish'] = {}
            connections = crittBroker.find('connections')
            self.mCrittBrokerData[name]['connections']['publish']['protocol'] = connections.find('publish').find('protocol').text
            self.mCrittBrokerData[name]['connections']['publish']['port'] = connections.find('publish').find('port').text
            self.mCrittBrokerData[name]['connections']['subscribe']['protocol'] = connections.find('subscribe').find('protocol').text
            self.mCrittBrokerData[name]['connections']['subscribe']['port'] = connections.find('subscribe').find('port').text
            self.mCrittBrokerData[name]['connections']['ui']['protocol'] = connections.find('ui').find('protocol').text
            self.mCrittBrokerData[name]['connections']['ui']['port'] = connections.find('ui').find('port').text
            self.mCrittBrokerData[name]['connections']['brokerPublish']['protocol'] = connections.find('brokerPublish').find('protocol').text
            self.mCrittBrokerData[name]['connections']['brokerPublish']['port'] = connections.find('brokerPublish').find('port').text

            self.mCrittBrokerData[name]['brokers'] = []
            for brokerConnection in connections.find('brokers'):
                self.mCrittBrokerData[name]['brokers'].append(brokerConnection.find('name').text)

    def __readCritters(self):
        critters = self.mRoot.find('infrastructure').find('critters')

        for critter in critters:
            crittnick = critter.find('crittnick').text
            self.mCritterData[crittnick] = {}
            self.mCritterData[crittnick]['crittnick'] = critter.find('crittnick').text
            self.mCritterData[crittnick]['host'] = critter.find('host').text
            self.mCritterData[crittnick]['crittBroker'] = critter.find('crittBroker').text
            # TODO: Naming convention: brokerName?
            brokerName = self.mCritterData[crittnick]['crittBroker']
            if brokerName in self.mCrittBrokerData:
                self.mCritterData[crittnick]['connections'] = {}
                self.mCritterData[crittnick]['connections']['publish'] = {}
                self.mCritterData[crittnick]['connections']['subscribe'] = {}
                self.mCritterData[crittnick]['connections']['publish']['protocol'] = self.mCrittBrokerData[brokerName]['connections']['subscribe']['protocol']
                self.mCritterData[crittnick]['connections']['publish']['host'] = self.mCrittBrokerData[brokerName]['host']
                self.mCritterData[crittnick]['connections']['publish']['port'] = self.mCrittBrokerData[brokerName]['connections']['subscribe']['port']
                self.mCritterData[crittnick]['connections']['subscribe']['protocol'] = self.mCrittBrokerData[brokerName]['connections']['publish']['protocol']
                self.mCritterData[crittnick]['connections']['subscribe']['host'] = self.mCrittBrokerData[brokerName]['host']
                self.mCritterData[crittnick]['connections']['subscribe']['port'] = self.mCrittBrokerData[brokerName]['connections']['publish']['port']
            else:
                # TODO: Make meaningful.
                raise Exception
            self.mCritterData[crittnick]['services'] = []
            for service in critter.find('services'):
                self.mCritterData[crittnick]['services'].append(service.text)

    def __startCrittBrokers(self):
        for crittBrokerData in self.mCrittBrokerData.itervalues():
            self.__startCrittBroker(crittBrokerData)

    def __startCritters(self):
        for critterData in self.mCritterData.itervalues():
            self.__startCritter(critterData)

    def __startCrittBroker(self, aCrittBrokerData):
        parameters = [
            'ssh',
            'crittuser@' + aCrittBrokerData['host'],
            'python',
            '/home/crittuser/sandbox/Critter/CrittBroker.py',
            '--name', aCrittBrokerData['name'],
            '--host', aCrittBrokerData['host'],
            '--publish', aCrittBrokerData['connections']['publish']['protocol'] + '*:' + aCrittBrokerData['connections']['publish']['port'],
            '--subscribe', aCrittBrokerData['connections']['subscribe']['protocol'] + aCrittBrokerData['host'] + ':' + aCrittBrokerData['connections']['subscribe']['port'],
            '--ui', aCrittBrokerData['connections']['ui']['protocol'] + aCrittBrokerData['host'] + ':' + aCrittBrokerData['connections']['ui']['port'],
            '--brokerPublish', aCrittBrokerData['connections']['brokerPublish']['protocol'] + '*:' + aCrittBrokerData['connections']['brokerPublish']['port']
        ]
        # TODO: Remove the hardcoded separator.
        for neighbour in aCrittBrokerData['brokers']:
            parameters += ['--broker', neighbour + ',' + self.mCrittBrokerData[neighbour]['connections']['brokerPublish']['protocol'] + self.mCrittBrokerData[neighbour]['host'] + ':' + self.mCrittBrokerData[neighbour]['connections']['brokerPublish']['port']]
        Popen(parameters)

    def __startCritter(self, aCritterData):
        Popen([
            'ssh',
            'crittuser@' + aCritterData['host'],
            'python',
            '/home/crittuser/sandbox/Critter/CrittInit.py',
            aCritterData['crittnick'],
            aCritterData['host'],
            aCritterData['connections']['publish']['protocol'],
            aCritterData['connections']['publish']['host'],
            aCritterData['connections']['publish']['port'],
            aCritterData['connections']['subscribe']['protocol'],
            aCritterData['connections']['subscribe']['host'],
            aCritterData['connections']['subscribe']['port'],
            aCritterData['services'][0]
        ])

if __name__ == "__main__":
    crittstarter = Crittstarter()
    crittstarter.start()
