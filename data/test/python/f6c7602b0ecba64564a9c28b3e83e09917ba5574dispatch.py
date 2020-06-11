# jsb/plugs/core/dispatch.py
#
#

""" this is the dispatch plugin that dispatches events to commands. """

## jsb imports

from jsb.lib.callbacks import last_callbacks
from jsb.lib.errors import NoSuchCommand, NoSuchUser

## basic logging

import logging
import copy

## defines

cpy = copy.deepcopy

## dispatch-precondition

def predispatch(bot, event):
    """ check whether we should check for commands. """
    if event.status == "done": logging.debug("dispatch - event is done .. ignoring") ; return
    if event.isremote(): logging.debug("dispatch - event is remote .. not dispatching") ; return
    #if event.isrelayed: logging.debug("dispatch - event is relayed .. not dispatching") ; return  
    return True

## dispatch-callback

def dispatch(bot, event):
    """ dispatch an event. """
    logging.info("dispatch - doing event %s" % event.tojson())
    if event.userhost in bot.ignore: logging.warn("%s - ignore on %s" % (bot.name, event.userhost)) ; return
    if event.nodispatch:
        logging.debug("dispatch - nodispatch option is set - ignoring %s" % event.userhost)
        return
    bot.status = "dispatch"
    if not event.bonded: event.bind(bot)
    bot.curevent = event
    go = False
    execstr = event.iscmnd()
    logging.debug("dispatch - execstr is %s" % execstr)
    try:
        if execstr:
            event.iscommand = True
            event.execstr = execstr
            #event.dontclose = True
            e = cpy(event)
            e.bind(bot)
            e.usercmnd = execstr.split()[0]
            e.txt = execstr
            e.showexception = True
            if not e.options: e.makeoptions()
            e.bind(bot)
            if event.chan and e.usercmnd in event.chan.data.silentcommands: e.silent = True
            e.shouldwait = True
            result = bot.plugs.dispatch(bot, e)
        else:
            logging.debug("dispatch - no go for %s (cc is %s)" % (event.auth or event.userhost, execstr))
            result =  None
    except NoSuchUser, ex: logging.error("no such user: %s" % str(ex)) ; result = None
    except NoSuchCommand: logging.info("no such command: %s" % event.usercmnd) ; result = None
    return result

## register callback

last_callbacks.add('PRIVMSG', dispatch, predispatch)
last_callbacks.add('MESSAGE', dispatch, predispatch)
last_callbacks.add('BLIP_SUBMITTED', dispatch, predispatch)
last_callbacks.add('WEB', dispatch, predispatch)
last_callbacks.add('CONSOLE', dispatch, predispatch)
last_callbacks.add('DCC', dispatch, predispatch)
last_callbacks.add('DISPATCH', dispatch, predispatch)
last_callbacks.add('CMND', dispatch, predispatch)
last_callbacks.add('CONVORE', dispatch, predispatch)
last_callbacks.add('TORNADO', dispatch, predispatch)
