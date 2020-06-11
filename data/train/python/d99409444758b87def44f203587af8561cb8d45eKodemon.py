import multiprocessing, signal, time
import KodemonUDPServer, KodemonAPI

def StartUDPServer():
	server = KodemonUDPServer.KodemonUDPServer()
	server.serve_forever()
	
def StartAPI():
	api = KodemonAPI.KodemonAPI(debug=False)
	api.run()
	
def sigintHandler(signum, frame):
	print 'Exiting'
	pUDP.terminate()
	pAPI.terminate()
	exit()

if __name__ == "__main__":	
	pUDP = multiprocessing.Process(target=StartUDPServer)
	pAPI = multiprocessing.Process(target=StartAPI)
	
	print 'starting udp'
	pUDP.start()
	
	print 'starting api'
	pAPI.start()
	
	signal.signal(signal.SIGINT, sigintHandler)