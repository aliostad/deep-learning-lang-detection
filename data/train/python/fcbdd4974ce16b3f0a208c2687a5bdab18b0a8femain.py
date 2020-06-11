import vk
import sys
from random import randint
from Classes.userController import userController
from Classes.vkAppController import vkAppController
from Classes.audioController import audioController

print(sys.version)

userController = userController()
userController.loadData()

vkApp = vkAppController()
vkapi = vk.API(vkApp.appId, userController.login, userController.password)
vkapi.scope = vkApp.scopes
accessToken = vkapi.get_access_token()#Access Token for my app

profiles = vkapi.users.get()
print("Hello " + profiles[0]['first_name']+' '+profiles[0]['last_name'])

#debug msg:
debug = randint(0,100)
debug = str(debug)
vkapi.status.set(text ="debug msg " + debug)#Test of VkAPI work

audioControll = audioController()
audioControll.getAudio(vkapi)