from applience import *
from controller import *

light = Light()
ceiling_fan = CeilingFan()
garage_door = GarageDoor()
stereo = Stereo()

remote_controller = RemoteController()
remote_controller.set_command(0,
                              LightOnCommand(light),
                              LightOffCommand(light))
remote_controller.set_command(1,
                              CeilingFanLowCommand(ceiling_fan),
                              CeilingFanOffCommand(ceiling_fan))
remote_controller.set_command(2,
                              CeilingFanMediumCommand(ceiling_fan),
                              CeilingFanOffCommand(ceiling_fan))
remote_controller.set_command(3,
                              CeilingFanHighCommand(ceiling_fan),
                              CeilingFanHighCommand(ceiling_fan))
remote_controller.set_command(4,
                              GarageDoorUpCommand(garage_door),
                              GarageDoorDownCommand(garage_door))
remote_controller.set_command(5,
                              StereoOnCommand(stereo),
                              StereoOffCommand(stereo))

print remote_controller
print '-' * 20

remote_controller.on_button_pushed(0)
remote_controller.off_button_pushed(0)
remote_controller.undo()
remote_controller.undo()
remote_controller.on_button_pushed(3)
remote_controller.on_button_pushed(4)
remote_controller.undo()
remote_controller.on_button_pushed(5)
