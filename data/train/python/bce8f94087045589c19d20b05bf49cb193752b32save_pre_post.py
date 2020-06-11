import time

import bpy
from bpy.app.handlers import persistent

@persistent
def save_pre(scene):
    print('Before Saving...')
    print(time.asctime())
    timer = 100000000
    while(timer > 0):
        try:
            timer -=1
        except KeyboardInterrupt as e:
            print (e)
            print (timer)
            break
    

@persistent
def save_post(scene):
    print(time.asctime())
    print('After Saving...')
    
bpy.app.handlers.save_pre.append(save_pre)
bpy.app.handlers.save_post.append(save_post)
