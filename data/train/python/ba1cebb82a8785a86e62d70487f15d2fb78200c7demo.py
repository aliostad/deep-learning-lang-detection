from src import *

lap = 'First'
saveMC = False
while (True):
	if (lap == 'First'):
		info = init.window_config(lap)
		lap = 'Second'
	else: info = init.window_config(lap, info=info)
	stimulus = init.create_stimulus(info)
	pagyme.show_stimulus(stimulus, 'MotionClouds-demo')
	if (lap == 'Second'):
		info2, saveMC = save.window_save(lap)
		if (saveMC): lap = 'end_init'
	elif (lap != 'First'):
		if (info2[7] == False):
			info2, saveMC = save.window_save(lap, info=info2)
		if (info2[7] == True): saveMC = False
	if (saveMC and info2[7] == False):
		save.movie(info, info2)
		info[0], info[1], info[2] = 256, 256, 32
