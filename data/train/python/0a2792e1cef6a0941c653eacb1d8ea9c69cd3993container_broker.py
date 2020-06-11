from swift.container.backend import ContainerBroker
from swift.common.utils import Timestamp
from time import time
import os


def show_result(is_deleted, is_empty):
    print 'deleted? %s\nempty? %s\n' % (is_deleted, is_empty)


if __name__ == '__main__':
    db_file = ':memory:'
    broker = ContainerBroker(db_file=db_file,
                             account='account',
                             container='container')
    broker.initialize(Timestamp(time()).internal, 0)

    obj = 'object'

    print 'put object:'
    broker.put_object(obj, Timestamp(time()).internal, 10, '', '')

    info, is_deleted = broker.get_info_is_deleted()
    show_result(is_deleted, broker.empty())

    print 'delete object:'
    broker.delete_object(obj, Timestamp(time()).internal)
    info, is_deleted = broker.get_info_is_deleted()
    show_result(is_deleted, broker.empty())

    print 'delete db:'
    broker.delete_db(Timestamp(time()).internal)
    info, is_deleted = broker.get_info_is_deleted()
    show_result(is_deleted, broker.empty())

    print 'put object:'
    broker.put_object(obj, Timestamp(time()).internal, 10, '', '')
    info, is_deleted = broker.get_info_is_deleted()
    show_result(is_deleted, broker.empty())

    print 'delete object:'
    broker.delete_object(obj, Timestamp(time()).internal)
    info, is_deleted = broker.get_info_is_deleted()
    show_result(is_deleted, broker.empty())
