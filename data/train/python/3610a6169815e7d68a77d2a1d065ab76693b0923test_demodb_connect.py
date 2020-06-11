from CUBRIDPy.CUBRIDConnection import *
import logging

logging.root.setLevel(logging.DEBUG)
logging.info('Executing test: %s...' % __file__)

conn = CUBRIDConnection()
conn.connect()
logging.info('Connect successful!')

assert conn._CAS_INFO[0] == 0x01
assert conn._CAS_INFO[1] == 0xFF
assert conn._CAS_INFO[2] == 0xFF
assert conn._CAS_INFO[3] == 0xFF

assert conn._BROKER_INFO[0] == 0x01
assert conn._BROKER_INFO[1] == 0x01
assert conn._BROKER_INFO[2] == 0x01
assert conn._BROKER_INFO[3] == 0x00
assert conn._BROKER_INFO[6] == 0x00
assert conn._BROKER_INFO[7] == 0x00

conn.close()

logging.info('Test completed.')


