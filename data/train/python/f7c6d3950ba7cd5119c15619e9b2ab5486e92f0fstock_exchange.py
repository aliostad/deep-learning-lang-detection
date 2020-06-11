"""
A simple stock exchange simulation
"""

import random
#############################
#STOCK EXCHANGE
#############################
equities={'Nokia':1000000,
          'Google': 2000000,
          'Apple': 2400000}

tally={'Laura': {'Nokia':0,
                 'Google':0,
                  'Apple':0},
       'John':{'Nokia':0,
                'Google':0,
                'Apple':0},
       'Mark': {'Nokia':0,
                 'Google':0,
                  'Apple':0}}

def purchase_stock(broker):
    """
    Broker buys 50 shares of each company
    """
    for company in equities.keys():
        equities[company]=equities[company]-50
    temp_dict=tally[broker]
    for company in temp_dict.keys():
        temp_dict[company]=temp_dict[company]+50

def sell_stock(broker):
    """
    Broker sells 25 shares of each company back to the exchange
    """
    temp_dict=tally[broker]
    for company in temp_dict.keys():
        if temp_dict[company]!=0:
            """
            Broker can sell shares back only if he/she bought it
            in the first place
            """
            temp_dict[company]=temp_dict[company]-25
            equities[company]=equities[company]+25
def reset_exchange():
    """
    Sets the tally of each broker to 0
    """
    tally={'Laura': {'Nokia':0,
                     'Google':0,
                      'Apple':0},
           'John':{'Nokia':0,
                    'Google':0,
                    'Apple':0},
           'Mark': {'Nokia':0,
                     'Google':0,
                      'Apple':0}}

def trade():
    for broker in tally.keys():
        probability=random.uniform(0,1)
        if probability>0.5:
            purchase_stock(broker)
        else:
            sell_stock(broker)

################################
#Functions for pretty printing
################################

def pretty_print_tally(dictionary):
    """
    Pretty prints a tally of stocks
    """
    for broker in dictionary.keys():
        print broker + ": "
        print "Equities"
        for company in dictionary[broker].keys():
            print company + ": " + str(dictionary[broker][company])
        print "#########################################################"

def pretty_print_exchange(dictionary):
    """
    Pretty prints the number of shares remaining of each company
    """
    for company in dictionary.keys():
        print company + ": " + str(dictionary[company])
##############################################
#After 10 days of trading at the exchange
##############################################
for i in range(10):
    trade()
    print "After day "+ str(i+1)
    pretty_print_tally(tally)
    print "****************************"
    pretty_print_exchange(equities)
