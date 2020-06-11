'''
Created on Dec 21, 2014

@author: Ben
'''


def create_new_default(directory: str, dest: dict, param: dict):
    ''' 
    Creates new default parameter file based on parameter settings 
    '''
    with open(directory, 'w') as new_default:
        new_default.write(
'''TARGET DESTINATION = {} 
SAVE DESTINATION = {}
SAVE DESTINATION2 = {}

SAVE STARTUP DEST1 = {}
SAVE STARTUP DEST2 = {}

SAVE TYPE DEST1 = {}
SAVE TYPE DEST2 = {}
'''.format(dest['target'], dest['save'], dest['save2'], 
           param["dest1_save_on_start"], param["dest2_save_on_start"],
           param["save_dest1"], param["save_dest2"])
                          )
