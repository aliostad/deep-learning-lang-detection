'''
Created on 24 avr. 2013

@author: guillaume
'''

from pprint import pprint


class Metrics(object):

    BROKER_in_nb_worker_reply = 'BROKER_in_nb_worker_reply'
    BROKER_out_nb_client_reply = 'BROKER_out_nb_client_reply'
    BROKER_in_nb_client_request = 'BROKER_in_nb_client_request'
    BROKER_out_nb_worker_request = 'BROKER_out_nb_worker_request'
    BROKER_in_invalid = 'BROKER_in_invalid'
    nb_inc = 0

    measures = {BROKER_in_nb_worker_reply: 0,
                BROKER_out_nb_client_reply: 0,
                BROKER_in_nb_client_request: 0,
                BROKER_out_nb_worker_request: 0,
                BROKER_in_invalid: 0}

    def __init__(self, params):
        '''
        Constructor
        '''
        pass

    @staticmethod
    def addmetric(metric):
        if not metric in Metrics.measures.keys():
            Metrics.measures[metric] = 0

    @staticmethod
    def inc(metric):
        Metrics.nb_inc = Metrics.nb_inc + 1

        if metric in Metrics.measures.keys():
            Metrics.measures[metric] = Metrics.measures.get(metric) + 1
        else:
            print 'Unknown metric:', metric

        if (Metrics.nb_inc % 1000 == 0):
            pprint(Metrics.measures)
