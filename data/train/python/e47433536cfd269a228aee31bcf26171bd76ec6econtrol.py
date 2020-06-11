from interface import Interface
import os
import time
import threading
import sys

controller = Interface()
if sys.argv[1] == 'a':
	controller.processTeams(controller.getLiveGames())
	controller.getLiveGames()
	controller.getSchedules()
	controller.getLeagues()
if sys.argv[1] =='A':
	controller.processTeams(controller.getLiveGames())
	controller.getLiveGames()
	controller.getSchedules()
	controller.getLeagues()
	controller.addLeagueLogos(controller.getLeagues())
if sys.argv[1] =='l':
	controller.addLeagueLogos(controller.getLeagues())

#Class for running tests

#Update known_teams.json

#Update live_games.json

#Update schedule.json

#Update leagues.json

#Add logos to leagues
#time.sleep(20)
#this shit takes forever, don't do it unless the schema changed
#