#This is the config file for this project.
#startup.py reads this.

# add our model directory to the search path.
#paths relative to main.py
model-path resource/model/
model-path resource/model/ships
model-path resource/model/weapons
model-path resource/model/shieldgens
model-path resource/model/environment
model-path resource/texture/
model-path resource/hud/
model-path resource/themes/
model-path resource/backgrounds/space/
model-path resource/backgrounds/
model-path resource/buttons/

texture-path resource/backgrounds/space/
texture-path resource/texture/
texture-path resource/particles/

#Activate Panda-Debug Toolset
#The hotkeys might interferre with the program.
want-directtools false
#Enable the Direct Session Panel on startup
want-tk false
#Show the current Frame-Rate
show-frame-rate-meter true
# performance analyse tool

win-size 860 540


#Needed for GUI
textures-power-2 up 
