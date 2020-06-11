from CUBRIDPy.CUBRIDConnection import *
import logging

logging.root.setLevel(logging.INFO)
logging.info('Executing test: %s...' % __file__)

conn = CUBRIDConnection()
conn.connect()

try:
    logging.info('%s: %s' % ('CAS data', ', '.join(map(str, conn.CAS_INFO))))
    logging.info('%s: %s' % ('BROKER info', ', '.join(map(str, conn.BROKER_INFO))))
    version = conn.get_db_version()
    logging.info('%s: %s' % ('CAS data', ', '.join(map(str, conn.CAS_INFO))))
    logging.info('%s: %s' % ('BROKER info', ', '.join(map(str, conn.BROKER_INFO))))
    logging.info('Database version retrieved: %s' % conn._db_version)
    assert len(version) >= 7 # x.x.x.xyzv
    assert version.startswith('9.1.')
finally:
    conn.close()

logging.info('Test completed.')


