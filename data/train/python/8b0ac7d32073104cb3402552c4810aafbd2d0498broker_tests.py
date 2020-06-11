import unittest
import thingsbus.broker
import nose.exc

class BrokerTests(unittest.TestCase):
    def test_snapshot_logic(self):
        raise nose.exc.SkipTest("need to write test....")

    def test_msgpack_decode_successful(self): 
        data_in = b'\x94\xb3bottlekid.prototype\xc0\x82\xabdht22_error\xa0\xa8metadata\x83\xa5loops\xce\x00\x00\x00'
        data_in += b'\x9a\xa9msgs_sent\xce\x00\x00\x00\x99\xacmsgs_dropped\xce\x00\x00\x00\x01\xd99https://github.c'
        data_in += b'om/mistakes-consortium/esp8266.bottlekids'

        self.assertEquals(thingsbus.broker.Broker.decode_mpack(data_in), [
            'bottlekid.prototype',
            None,
            {
                'metadata': {
                    'msgs_dropped': 1,
                    'loops': 154,
                    'msgs_sent': 153
                },
                'dht22_error': ''
            },
            'https://github.com/mistakes-consortium/esp8266.bottlekids'
        ])
