from db.repositories import WorldRepository
from game.world import World

class WorldService(object):
  """
  High level world service class to perform world crud
  """
  
  def __init__(self, repository):
    self.worldRepository = repository
  
  def getWorldByName(self, worldName):
    """
    Gets a L{World} domain object by its name
    """
    w = World()
    w.name = worldName
    self.worldRepository.getWorld(w)
    return w
    
  def saveWorld(self, world):
    """
    Persists a L{World} domain object.
    """
    self.worldRepository.saveWorld(world)