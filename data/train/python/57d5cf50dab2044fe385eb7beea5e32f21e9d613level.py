from pygame import *
import save_point

"""Facilities for making common level primitives, like save points and spawn
locations, trigger correctly based on their tags."""


def activateLevelPrimitives():
    activateSavePoints()
    triggerSpawnLocation()


def activateSavePoints():
    savePoints = scene().GetAllTagged('SavePoint')
    for savePoint in savePoints:
        save_point.addSavePoint(GameEntity(savePoint))


def triggerSpawnLocation():
    spawnLocation = scene().GetFirstTagged('SpawnLocation')
    if spawnLocation:
        pos = spawnLocation.position()
        scene().GetFirstTagged('Player').SetPosition(pos)
        scene().camera().transform.position = pos
