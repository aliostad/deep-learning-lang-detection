import os
import win32api
import SaveSwap
import time

if (win32api.MessageBox(0,"Remove all save files create by SaveSwap?", "Uninstall script",4) != 6):
    exit()

print "Removing save files"
x = SaveSwap.SaveSwap()
x.delsaves()

print "The original save is still avaible to reset your save file if you so choose..."
time.sleep(2)

print "Removing SaveSwap from your pc..."
time.sleep(1)
del(x)
for i in os.listdir(os.getcwd()):
    if i == "uninstall.py":
        continue
    os.remove(os.getcwd() + "\\" + i)
    print "Removed " + i + "..."

os.remove("uninstall.py")

