# coding=UTF-8
'''Last Action Reporting Format'''
import cPickle as pickle
from datetime import datetime
from bellum.stats import LARFDATABASE_ROOT
from bellum.stats.larf.processors.alliance import LA_LIST, dispatch as LA_dispatch
from bellum.stats.larf.processors.mothership import LM_LIST, dispatch as LM_dispatch
from bellum.stats.larf.processors.province import LP_LIST, dispatch as LP_dispatch
from bellum.stats.larf.processors.attack import LX_LIST, dispatch as LX_dispatch

def note(request, action, *args, **kwargs):
    '''General dispatcher for LARF requests'''
    if action in LA_LIST:
        LA_dispatch(request, action, *args, **kwargs)
    if action in LM_LIST:
        LM_dispatch(request, action, *args, **kwargs)
    if action in LP_LIST:
        LP_dispatch(request, action, *args, **kwargs)
    if action in LX_LIST:
        LX_dispatch(request, action, *args, **kwargs)

