import unittest
import sys
sys.path.append('../src/')
from smsBroker import SmsBroker
import json

class SmsBrokerUnitTests(unittest.TestCase):
    def test_that_it_bloody_works(self):
        #/SMS?ToCountry=GB&ToState=Leicester&SmsMessageSid=SM32dc398b725d3a62a7875b06171f174b&NumMedia=0&ToCity=&FromZip=&SmsSid=SM32dc398b725d3a62a7875b06171f174b&FromState=&SmsStatus=received&FromCity=&Body=Test&FromCountry=GB&To=%2B441163262273&ToZip=&MessageSid=SM32dc398b725d3a62a7875b06171f174b&AccountSid=AC3700d9ec5419d1a4405e9e7338a7fd72&From=%2B447903120756&ApiVersion=2010-04-01
        body = "Test"
        number = "%2B447903120756"
        smsBroker = SmsBroker()
        processedMessage = smsBroker.processTextMessage(number, body)
        assert processedMessage

if __name__ == '__main__':
    unittest.main()