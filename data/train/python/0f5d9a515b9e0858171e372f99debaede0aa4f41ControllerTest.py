'''
Created on Oct 20, 2015

@author: sum
'''
import unittest
import CA03.prod.Controller as Controller

class Test(unittest.TestCase):

    def test100_010_ShouldConstruct(self):
        self.assertIsInstance(Controller.Controller(), Controller.Controller)

    def test200_010_ShouldInitializeWithArchitectureFile(self):
        myController = Controller.Controller()
        architectureFile = "file.xml"
        result = ['Device', 'StarSensor']
        self.assertEquals(myController.initialize(architectureFile), result) 
        
    def test200_020_ShouldInitializeWithArchitectureFileReturnEmptyList(self):
        myController = Controller.Controller()
        architectureFile = "file2.xml"
        self.assertEquals(myController.initialize(architectureFile), [])    
        
    def test200_030_ShouldInitializeWithNewArchitectureFile(self):
        myController = Controller.Controller()
        architectureFile = "file3.xml"
        result = ['Device', 'StarSensor', 'SolarCollector']
        self.assertEquals(myController.initialize(architectureFile), result)     
        
    def test200_910ShouldRaiseExceptionOnIncorrectFileName(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="Xfile.xml") 
    
    def test200_920ShouldRaiseExceptionOnIncorrectFileExtension(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="file.csv")     
            
    def test200_930ShouldRaiseExceptionOnFileNameLessThanOne(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile=".xml")     
     
    def test200_940ShouldRaiseExceptionOnMissingFileName(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize()                   

    def test200_950ShouldRaiseExceptionOnFileNotString(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile=2)
    
    def test200_960ShouldRaiseExceptionOnFileEmpty(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="Empty.xml")
            
    def test200_970ShouldRaiseExceptionOnInvalidRateData(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="invalid1.xml")
            
    def test200_980ShouldRaiseExceptionOnInvalidDeviceType(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="invalid2.xml")    
    
    def test200_990ShouldRaiseExceptionOnInvalidDeviceName(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="invalid3.xml")
            
    def test200_9910ShouldRaiseExceptionOnInvalidDeviceParm(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="invalid4.xml")
    
    def test200_9920ShouldRaiseExceptionOnMissingDeviceParm(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="invalid5.xml")                
    
    def test200_9930ShouldRaiseExceptionOnInvalidFrameRate(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="invalid6.xml") 
            
    def test300_010_ShouldRunController(self):
        myController = Controller.Controller()
        myController.initialize(architectureFile="frameConfiguration.xml")
        self.assertEquals(myController.run(10000000), 10000000)
        
    def test300_020_ShouldRunControllerWithMicrosecondsLessThanFrameRate(self):
        myController = Controller.Controller()
        myController.initialize(architectureFile="frameConfiguration.xml")
        self.assertEquals(myController.run(40), 120)    
    
    def test300_030_ShouldRunControllerWithMicrosecondsGTFrameRate(self):
        myController = Controller.Controller()
        myController.initialize(architectureFile="frameConfiguration2.xml")
        self.assertEquals(myController.run(1000), 1200)  
           
    def test300_910ShouldRaiseExceptionOnMissingMicroseconds(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="frameConfiguration.xml")
            myController.run()
            
    def test300_920ShouldRaiseExceptionOnMicrosecondsLessThanEqualToZero(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="frameConfiguration.xml") 
            myController.run(0)
    
    def test300_930ShouldRaiseExceptionOnMicrosecondsNotAnInteger(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller()
            myController.initialize(architectureFile="frameConfiguration.xml")    
            myController.run("abc")  
    def test300_940ShouldRaiseExceptionOnMissingInitialization(self):
        with self.assertRaises(ValueError) as context:
            myController = Controller.Controller() 
            myController.run(1000)             