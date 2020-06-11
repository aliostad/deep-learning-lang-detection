import sys, traceback, Ice,IceGrid
Ice.loadSlice('-I {} Geocloud.ice'.format(Ice.getSliceDir()))
import geocloud
import sys
import time
class GroundStation(Ice.Application):
    def run(self,args):
        com = self.communicator()
        if not com:
            raise RuntimeError("Not communicator")

        else:
            print "ID:",args[0]
            query = com.stringToProxy('IceGrid/Query')
            q = IceGrid.QueryPrx.checkedCast(query)
            if not q:
                raise RuntimeError("Invalid proxy")
            try:
                broker = q.findObjectById(com.stringToIdentity('broker'))
                brokerPrx = geocloud.BrokerPrx.checkedCast(broker)
                print brokerPrx

                orch = q.findObjectById(com.stringToIdentity('orchestrator'))
                orchestratorPrx = geocloud.OrchestratorPrx.checkedCast(orch)
                print orchestratorPrx
            except Exception as e:
                print e
                sys.exit(-1)

           # for i in range(1,3):
                #orchestratorPrx.downloadedImage("imagen"+str(i))
                #orchestratorPrx.cleanQueue()

                #time.sleep(1.0);
            brokerPrx.begin_startScenario(1)
            sys.exit(0)


if __name__=="__main__":
    c = GroundStation(1)
    sys.exit(c.main(sys.argv))
