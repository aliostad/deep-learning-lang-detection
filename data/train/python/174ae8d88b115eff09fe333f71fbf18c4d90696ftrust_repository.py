from pydssim.peer.repository.abstract_repository import AbstractRepository
from pydssim.peer.repository.trust_final_repository import TrustFinalRepository
from pydssim.peer.repository.direct_trust_repository import DirectTrustRepository

class TrustRepository(AbstractRepository):
    
   
    
    def __init__(self, peer):
        
        self.__direct = DirectTrustRepository(peer)
        self.__trustf = TrustFinalRepository(peer)
        
        self.initialize(peer,typeRepository="TrustRepository")
        
        self.addElement(self.__direct)
        self.addElement(self.__trustf)
        
   
    