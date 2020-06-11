"""
Created on Mon Jan 02 20:18:09 2017

@author: Noppharut
"""
import switchPOX
import switchRyu
from rwlock import RWLock


if __name__ == '__main__':

    threads = []
    dictAllActivePortInTDA = {}
    lock = RWLock()
    try:
        f = open("TDAConfig.txt")

        #Controller
        controller = f.readline()
        controller = controller.split("=")
        controller = controller[1].strip()
        #Controller IP
        controllerIP = f.readline()
        controllerIP =  controllerIP.split("=")
        controllerIP = controllerIP[1].strip()

        #Controller Port
        controllerPort = f.readline()
        controllerPort = controllerPort.split("=")
        controllerPort = controllerPort[1].strip()
        
        #Mininet Option
        mininetOption = f.readline()
        mininetOption = mininetOption.split("=")
        mininetOption = mininetOption[1].strip()

        #Community String
        communityString = f.readline()
        communityString = communityString.split("=")
        communityString = communityString[1].strip()

        
        print("Controller ip : " + controllerIP)
        print("Controller port : " + controllerPort)
        print("Mininet Option : " + mininetOption)
        print("Community String : " + communityString)
        
        for switchIP in f:
            try:
                print(switchIP.replace("\n",""))

                if controller.lower() == "pox":
                    thread = switchPOX.Switch( controllerIP , int(controllerPort) , 8192 , switchIP.replace("\n","") , dictAllActivePortInTDA , lock , int(mininetOption) , communityString )
                else:
                    thread = switchRyu.Switch( controllerIP , int(controllerPort) , 8192 , switchIP.replace("\n","") , dictAllActivePortInTDA , lock , int(mininetOption) , communityString )
                thread.start()
                threads.append(thread)
            except Exception as err:
                print( "Handling run-time error : " + str(err) )


        for t in threads:
            t.join()
        
    except Exception as err:
        print( "Handling run-time error : " + str(err) )

    f.close()  


"""
    threads = []

    thread1 = switch.Switch( '192.168.90.101' , 6633 , 8192 , '192.168.90.110' )
    thread1.start()
    threads.append(thread1)


    for t in threads:
        t.join()
    
    print("TDA Ending")
"""
