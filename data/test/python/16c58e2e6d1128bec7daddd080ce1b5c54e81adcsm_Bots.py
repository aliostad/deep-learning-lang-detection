#!/usr/bin/python

# Std Lib
import  curses

# Custom Modules
from    baseMenu import Option
from    sm_Base  import sm_Base
from    sm_Dns   import sm_Dns
from    sm_Json  import sm_Json
from    sm_SQL   import sm_SQL
from    sm_Mx    import sm_Mx

class sm_Bots( sm_Base ):

    def __init__( self, option, CommandAndControl ):

        super( sm_Bots, self ).__init__(
            x_src   = 5,
            lines   = 6,
            cnc     = CommandAndControl,
            options = {
                'DNS Broker'  : Option(
                    order   = 0,
                    hotkeys = [ ord( 'd' ), ord( 'D' ) ],
                    method  = sm_Dns,
                    display = [ ["D"], "NS Broker" ],
                ),

                'JSON Broker' : Option(
                    order   = 1,
                    hotkeys = [ ord( 'j' ), ord( 'J' ) ],
                    method  = sm_Json,
                    display = [ ["J"], "SON Broker" ],
                ),

                'SQL Broker'  : Option(
                    order   = 2,
                    hotkeys = [ ord( 's' ), ord( 'S' ) ],
                    method  = sm_SQL,
                    display = [ ["S"], "QL Broker" ], 
                ),

                'MX Broker'   : Option(
                    order   = 3,
                    hotkeys = [ ord( 'm' ), ord( 'M' ) ],
                    method  = sm_Mx,
                    display = [ ["M"], "X Broker" ],
                ),
            },
        )

    def obtainInput( self, option, cnc ):
        screen = curses.newwin( 3, 65, 4, 6 )
        screen.box()
        screen.addstr( 1, 2, " "*59, curses.A_UNDERLINE )
        screen.refresh()

        curses.echo()
        curses.nocbreak()
        data_in = screen.getstr( 1, 2 )
        curses.noecho()
        curses.cbreak()

        return ( option, data_in )

