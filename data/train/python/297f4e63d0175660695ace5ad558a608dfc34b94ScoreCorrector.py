'''
Runs an analyzer to determine score corrections across the games in a tournament.
'''

import string,os,subprocess
import TournamentGameIterator as tgi

class ScoreCorrector:

    def __init__ (self,
                  url='http://ts.powertac.org/log_archive/finals_2016_06',
                  tournament='finals-201606'):
        self.tournament = tournament
        self.tournamentURL = url
        self.data = 'data'
        self.prefix = 'capacityVariance-'
        self.processEnv = {'JAVA_HOME': '/usr/lib/jvm/java-8-oracle'}
        self.gameDir = '../../games'
        self.logtoolDir = '../logtool-examples'

    def reset (self):
        # data store
        self.gameData = []
        self.brokerData = {}

    # data-type parameters
    logtoolClass = 'org.powertac.logtool.example.CapacityValidator'

    def dataIterator (self, force=False):
        '''
        Processes data from boot and state log files in the specified directory.
        Use force=True to force re-analysis of the data. Otherwise the logtool
        code won't be run if its output is already in place. '''
        return (self.processGame(game)
                for game in tgi.logIter(self.tournamentURL,
                                        os.path.join(self.gameDir,
                                                     self.tournament)))

    def processGame (self, game):
        '''
        Runs the logtool class against the contents of the game dir,
        producing an output file containing lines as game, broker, variance.
        Returns the path to the data file. '''
        datafileName = self.prefix+game+'.data'
        if os.path.exists(os.path.join(self.logtoolDir, self.data, datafileName)):
            return datafileName
        args = ''.join([self.logtoolClass, ' ',
                        os.path.join(self.gameDir, self.tournament, game), ' ',
                        os.path.join(self.data, datafileName)])
        subprocess.check_output(['mvn', 'exec:exec',
                                 '-Dexec.args=' + args],
                                env = self.processEnv,
                                cwd = self.logtoolDir)
        return datafileName

    def extractData (self, datafileName):
        datafile = open(os.path.join(self.logtoolDir, self.data, datafileName), 'r')
        # each line is game, broker, correction
        content = [line.rstrip() for line in datafile.readlines()]
        gamesize = len(content)
        for line in content:
            tokens = line.split(', ')
            game = tokens[0]
            broker = tokens[1] + '-' + str(len(content) - 1)
            correction = self.floatMaybe(tokens[2])
            if abs(correction) > 0.1:
                print('game {}, broker {}, correction = {}'.format(game, broker, correction))
            if not broker in self.brokerData:
                self.brokerData[broker] = 0.0
            self.brokerData[broker] = self.brokerData[broker] + correction

    def floatMaybe (self, str):
        '''returns the float representation of a string, unless the string is
         empty, in which case return 0. Should have been a lambda, but not
         with Python. '''
        result = 0.0
        if str != '' :
            result = float(str)
        else:
            print('failed to float', str)
        return result

    def processTournament (self):
        self.reset()
        for datafileName in self.dataIterator():
            self.extractData(datafileName)
        print("results:")
        for broker in sorted(self.brokerData):
            print(broker, self.brokerData[broker])
