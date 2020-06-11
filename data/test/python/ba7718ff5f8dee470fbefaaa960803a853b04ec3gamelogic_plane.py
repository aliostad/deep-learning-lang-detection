import bge

controller = bge.logic.getCurrentController()
owner = controller.owner

leftArrow = controller.sensors['LeftArrow']
rightArrow = controller.sensors['RightArrow']
upArrow = controller.sensors['UpArrow']
downArrow = controller.sensors['DownArrow']

delta = 0.01

planeMotion=controller.actuators['PlaneMotion']

if leftArrow.positive:
    planeMotion.dRot = [0.0, -delta, 0.0]
    controller.activate(planeMotion)
elif rightArrow.positive:
    planeMotion.dRot = [0.0, delta, 0.0]
    controller.activate(planeMotion)
elif upArrow.positive:
    planeMotion.dRot = [-delta, 0.0,  0.0]
    controller.activate(planeMotion)
elif downArrow.positive:
    planeMotion.dRot = [delta, 0.0, 0.0]
    controller.activate(planeMotion)
else:
    controller.deactivate(planeMotion)