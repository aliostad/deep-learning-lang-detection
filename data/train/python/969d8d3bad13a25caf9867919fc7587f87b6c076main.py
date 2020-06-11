#!/usr/bin/env python3

# -*- coding: utf-8 -*-

from objects import botcontroller
from objects import basebot, chatbot
from objects.commands import commandbot

SERVER1 = "crimson.lostsig.net"
SERVER2 = "irc.skulltag.com"
PORT    = 6667

if __name__ == "__main__":
    controller = botcontroller.BotController()

    bot1 = commandbot.CommandBot(SERVER1, PORT, controller)
    #bot2 = commandbot.CommandBot(SERVER2, PORT, controller)
    # ~ bot = chatbot.ChatBot(SERVER, PORT, controller)
    # ~ bot = basebot.BaseBot(SERVER, PORT, controller)

    bot1Num = controller.startBot(bot1)
    #bot2Num = controller.startBot(bot2)
