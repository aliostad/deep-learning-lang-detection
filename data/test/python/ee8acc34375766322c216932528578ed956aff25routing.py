#################################################################
#
# CoreCodex - Online Assessment Tool of Programming Challenges
# Copyright 2011 Core S2 - Software Solutions - See License.txt for info
# 
# This source file is developed and maintained by:
# + Jeremy Bridon jbridon@cores2.com
# 
# File: routing.py
# Info: Routing information / direction information for
# controller responses.
# 
#################################################################

# Standard includes
from routes import Mapper

def make_map(config):
	
	# Base mapping
	map = Mapper(directory=config['pylons.paths']['controllers'], always_scan=config['debug'])
	map.minimization = False
	map.explicit = False
	
	# The ErrorController route (handles 404/500 error pages); it should
	# likely stay at the top, ensuring it can always be resolved
	map.connect('/error/{action}', controller='error')
	map.connect('/error/{action}/{id}', controller='error')
	
	# CUSTOM ROUTES HERE
	
	# Redirect root directory to main (home) controller
	map.connect('/', controller="main", action="index")
	
	# Redirect helps / about / bottom links
	map.connect('/about', controller="help", action="about")
	map.connect('/contact', controller="help", action="contact")
	map.connect('/license', controller="help", action="license")
	map.connect('/policy', controller="help", action="policy")
	map.connect('/help', controller="help", action="help")
	map.connect('/achievements', controller="help", action="achievements")
	
	# Redirect user login, logout, registration, or deletion
	map.connect('/login', controller="users", action="login")
	map.connect('/logout', controller="users", action="logout")
	map.connect('/register', controller="users", action="register")
	map.connect('/unregister', controller="users", action="unregister")
	map.connect('/preferences', controller="users", action="preferences")
	map.connect('/recover', controller="users", action="recover")
	map.connect('/users/*url', controller="users", action="user_view")
	map.connect('/leaderboard', controller="users", action="leaderboard")
	
	# Admin pages (protected)
	map.connect('/admin', controller="admin", action="admin")
	
	# Redirect for specific challenges and grouped challenges
	map.connect('/challenge/*url', controller="challenge", action="challenge_view")
	map.connect('/challenges/view', controller="challenges", action="challenges_view")
	map.connect('/challenges/*url', controller="challenges", action="challengegroup_view")
	
	# Redirect for submissions and results
	map.connect('/submit/*url', controller="submit", action="submit_view")
	map.connect('/results/*url', controller="results", action="results_view")
	map.connect('/result/*url', controller="results", action="result_view")
	
	# Generic redirects
	map.connect('/{controller}/{action}')
	map.connect('/{controller}/{action}/{id}')
	
	return map
