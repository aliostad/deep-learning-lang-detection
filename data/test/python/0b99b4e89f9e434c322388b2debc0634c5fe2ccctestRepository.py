import unittest
from organizer.repository import Repository

class TestRepository(unittest.TestCase):
    def testQueryListReturnsNoneForNoMatches(self):
        repository = Repository("fakedir")
        theList = ["foo", "bar", "biz", "bat"]
        self.assertEquals(None, repository._queryList("bilbo", theList))
        
    def testQueryListReturnsBestMatch(self):
        repository = Repository("fakedir")
        theList = ["bil", "billbo", "BILbiz", "BILBO"]
        self.assertEquals("BILBO",repository._queryList("bilbo", theList))
        
    def testScoreNameIncreasesByTenForExactMatches(self):
        repository = Repository("fakedir")
        masterList = [[0,"bil"], [1,"billbo"], [2,"BILbiz"], [3,"BILBO"]]
        repository._scoreName("bilbo", masterList)
        self.assertEquals([13,"BILBO"],masterList[3])

    def testScoreNameIncreasesByOneForPartialMatches(self):
        repository = Repository("fakedir")
        masterList = [[0,"bil"], [1,"billbo"], [2,"BILbiz"], [3,"BILBO"]]
        repository._scoreName("bi",masterList)
        self.assertEquals([4,"BILBO"],masterList[3])
        
    def testScoreNameNotIncreaseOnNonMatch(self):
        repository = Repository("fakedir")
        masterList = [[0,"bil"], [1,"billbo"], [2,"BILbiz"], [3,"BILBO"]]
        repository._scoreName("xx",masterList)
        self.assertEquals([3,"BILBO"],masterList[3])
        
    def testScoreNameNotIncreaseOnBlankMatch(self):
        repository = Repository("fakedir")
        masterList = [[0,"bil"], [1,"billbo"], [2,"BILbiz"], [3,"BILBO"]]
        repository._scoreName("",masterList)
        self.assertEquals([3,"BILBO"],masterList[3])


        