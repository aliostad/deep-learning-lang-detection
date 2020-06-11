#-----------------------------------------------------------------------------
# Name:        BoaDebugger.py
# Purpose:     Enable Zope debugging with Boa Constructor
#
# Authors:      phil@bluedynamics.com, gogo@bluedynamics.com
#	            robert@bluedynamics.com	
#               Alan Miligan
#
# Created:     2003/13/02
# RCS-ID:      $Id$
# Copyright:   (c) 2002 - 2004
# Licence:     GPL
#-----------------------------------------------------------------------------

import Globals
import sys, traceback
from AccessControl.Permissions import view_management_screens
from OFS.PropertyManager import PropertyManager
from OFS.SimpleItem import SimpleItem
from Boa.RemoteServer import start, stop

True, False = 1, 0

def manage_addBoaDebugger(self, REQUEST=None):
    """
    Factory Method
    """
    self._setObject('BoaDebugger', BoaDebugger())
    if REQUEST:
        REQUEST.RESPONSE.redirect('%s/manage_main' % REQUEST['URL3'])

class BoaDebugger (PropertyManager, SimpleItem):
    """
    A BoaDebugger plug-in for your Zope
    """

    meta_type = 'BoaDebugger'
    id = 'Boa Debugger'
    title = 'Boa Constructor Zope debug module'
    icon = 'www/boa.gif'
        
    __ac_permissions__ = PropertyManager.__ac_permissions__ + (
        (view_management_screens, ('manage_start', 'manage_stop', 'manage_callBreakpoint')),
        ) + SimpleItem.__ac_permissions__

    property_extensible_schema__ = 0
    _properties = PropertyManager._properties + (
        # why would you change this??? {'id':'host',     'type':'string', 'mode':'w'},
        {'id':'port',     'type':'int',    'mode':'w'},
        {'id':'username', 'type':'string', 'mode':'w'},
        {'id':'password', 'type':'string', 'mode':'w'},
        )
    
    manage_options = (
        { 'label': 'Properties', 'action':'manage_main',
          'help': ('BoaDebugger', 'debugger.stx') },
        { 'label': 'Start', 'action':'manage_start' },
        { 'label': 'Stop', 'action':'manage_stop' },
        { 'label': 'Breakpoint Mode', 'action':'manage_callBreakpoint' },
        ) + SimpleItem.manage_options

    manage_main = PropertyManager.manage_propertiesForm
    
    def __init__(self):
        self.username = ''
        self.password = ''
        self.host='localhost'
        self.port = 26200

    def manage_start(self,REQUEST=None):
        """ """
        if getattr(self, '_v_active', False):
            REQUEST.set('manage_tabs_message', 'The debug server is already active')
            return self.manage_main(self, REQUEST)            
        try :
            self._v_active = True
            start(self.username, self.password, self.host, self.port)
        except Exception, e:
            if REQUEST:
                typ, val, tb = sys.exc_info()
                s = "The debug server could not be started.<br>%s<br>\n" % traceback.format_exception(typ, val, tb)
                REQUEST.set('manage_tabs_message', s)
                return self.manage_main(self, REQUEST)
            else:
                raise
        if REQUEST:
            REQUEST.set('manage_tabs_message', 'The debug server is active now')
            return self.manage_main(self, REQUEST)
        
    def manage_stop(self, REQUEST=None):
        """ """
        if not getattr(self, '_v_active', False):
            if REQUEST:
                REQUEST.set('manage_tabs_message', 'The debug server is already stopped')
                return self.manage_main(self, REQUEST)
            else:
                return
        try :
            self._v_active = False
            stop()
        except Exception, e:
            if REQUEST:
                typ, val, tb = sys.exc_info()
                s = "The debug server could not be stopped.<br>%s<br>\n" % traceback.format_exception(typ, val, tb) + "<br>\n"
                REQUEST.set('manage_tabs_message', s)
                return self.manage_main(self, REQUEST)
            else:
                raise

        if REQUEST:
            REQUEST.set('manage_tabs_message', 'The debug server is stopped now')
            return self.manage_main(self, REQUEST)

    def manage_callBreakpoint(self, REQUEST=None):
        '''
        sets a breakpoint and places the Zope server in debug mode proper!
        '''
        if not self._v_active:
            if REQUEST:
                REQUEST.set('manage_tabs_message', 'BoaDebugger is inactive!')
                return self.manage_main(self, REQUEST)
    
        if hasattr(sys, 'breakpoint'):
            try:
                
                sys.breakpoint()
                # This is a hardcoded breakpoint.
                
                if REQUEST:
                    REQUEST.set('manage_tabs_message', 'Breakpoint Added')
                    return self.manage_main(self, REQUEST)
                return
            except Exception, e:
                if REQUEST:
                    REQUEST.set('manage_tabs_message', str(e))
                    return self.manage_main(self, REQUEST)
                raise

        if REQUEST:
            REQUEST.set('manage_tabs_message', '''The 'sys' module does not provide breakpoints.''')
            return self.manage_main(self, REQUEST)
        else:
            raise NotImplementedError, '''The 'sys' module does not provide breakpoints.'''

Globals.InitializeClass(BoaDebugger)
