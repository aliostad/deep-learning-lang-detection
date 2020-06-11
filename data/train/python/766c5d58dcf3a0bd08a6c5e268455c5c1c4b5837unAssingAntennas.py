from CCL.Antenna import Antenna
for i in range(1,25+1):
    antenna = 'DV'+str(i).zfill(2)
    a = Antenna(antenna)
    if a._HardwareController__controller.isAssigned() is True:
        a._HardwareController__controller.unassign()
for i in range(1,4+1):
    antenna = 'PM'+str(i).zfill(2)
    a = Antenna(antenna)
    if a._HardwareController__controller.isAssigned() is True:
        a._HardwareController__controller.unassign()

for i in range(1,12+1):
    antenna = 'CM'+str(i).zfill(2)
    a = Antenna(antenna)
    if a._HardwareController__controller.isAssigned() is True:
        a._HardwareController__controller.unassign()

for i in range(41,65+1):
    antenna = 'DA'+str(i).zfill(2)
    a = Antenna(antenna)
    if a._HardwareController__controller.isAssigned() is True:
        a._HardwareController__controller.unassign()

