import models
import os

__author__ = 'Andrei'

from manager import Manager

import web

class BaseView(object):
    def __init__(self):
        self.broker = Manager()

class init(BaseView):
    def GET(self):

        return "Hello,World!"

class state(BaseView):
    def GET(self):
        return self.broker.getField().toxml()

class seed(BaseView):
    def GET(self, x_coord, y_coord, plant_id):
        if not x_coord:
            return models.Error().asXML("1","No X coord specified")
        if not y_coord:
            return models.Error().asXML("2","No Y coord specified")
        if not plant_id:
            return models.Error().asXML("3","Unknown Plant")
        if not self.broker.seedPlant(x_coord, y_coord, plant_id):
            return models.Error().asXML("4","Can't seed plant at specified coords")
        return self.broker.getField().toxml()

class dig(BaseView):
    def GET(self, x_coord, y_coord):
        if not y_coord:
            y_coord = None

        if not self.broker.digPlant(x_coord, y_coord):
            return models.Error().asXML("5","Can't dig. No plant or plant is not grown up")
        else:
            return self.broker.getField().toxml()

class turn(BaseView):
    def GET(self):
        self.broker.updateField()
        return self.broker.getField().toxml()


class image(BaseView):
    def GET(self,plant_id,state_id=None):

        cType = {
            "png":"images/png",
            "jpg":"image/jpeg",
            "gif":"image/gif",
            "ico":"image/x-icon"}

        if not plant_id: # background image requested
            sprite_name,image = self.broker.getBackgroundImage()
        else:
            sprite_name,image = self.broker.getPlantImage(plant_id,state_id)

        if not(sprite_name or image):
            return models.Error().asXML("6","No Image for plant")

        ext =  sprite_name.split('.')[-1] # get extension

        web.header("Content-Type", cType[ext]) # Set the Header
        return image

class list(BaseView):
    def GET(self):
        return self.broker.getPlants().toxml();

def notFound():
    return web.notfound("Unknown command")
