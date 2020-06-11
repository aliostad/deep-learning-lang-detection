from Bag import Bag
from Roulette import Roulette
from BagMixer import BagMixer
import random

class CrossController():
    def __init__(self, bagsController):
        self.bagsController = bagsController
        self.roulette = Roulette(self.bagsController.bags,
                                 self.bagsController.bagParams.numOfBags)
        self.bagMixer = BagMixer(self.bagsController)
        
    def CrossBags(self):
        idxOfBagsForRepro = self.roulette.DrawBagsIdxForRepr()
        self.bagMixer.MixBags(idxOfBagsForRepro)
         
        
        