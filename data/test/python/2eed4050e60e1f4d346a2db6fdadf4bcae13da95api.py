
import bottle


api = bottle.Bottle();
api.config.id = "api"
api.config.prefix = "/api"
api.config.path = "api/"


import project

project.api.config.id = lambda: api.config.id + ".project"
project.api.config.prefix = "/project"
project.api.config.path = lambda: api.config.path + project.api.config.prefix
    
api.mount(app=project.api, prefix=project.api.config.prefix)
    
    
    
import application

application.api.config.id = lambda: api.config.id + ".application"
application.api.config.prefix = "/application"
application.api.config.path = lambda: api.config.path + application.api.config.prefix
    
api.mount(app=application.api, prefix=application.api.config.prefix)



import run

run.api.config.id = lambda: api.config.id + ".run"
run.api.config.prefix = "/run"
run.api.config.path = lambda: api.config.path + run.api.config.prefix

api.mount(app=run.api, prefix=run.api.config.prefix)


