# Copyright 2013 Simon Dominic Hibbs

NO_GUIDE = 0
LOCAL_GUIDE= 1
BLACK_MARKET_GUIDE = 2

class MerchantData(object):
    def __init__(self):

        self.passengerCheckEffect = 0
        self.stewardSkills = []
        self.highPassengerLimit = 0
        self.midPassengerLimit = 0
        
        self.bestMailRank = 0
        self.bestSoc = 0
        self.shipIsArmed = False
        
        self.guideOption = NO_GUIDE
        self.guideCost = 0

        self.useLocalBroker = False
        self.localBrokerDM = 0
        self.localBrokerMargin = 0
        self.bestIntOrSoc = 0
        self.bestBroker = None
        


        
