#coding=utf-8

import Image
import win32gui, win32ui, win32con, win32api  

hwnd = 0 
hwndDC = win32gui.GetWindowDC(hwnd)   
mfcDC=win32ui.CreateDCFromHandle(hwndDC)   
saveDC=mfcDC.CreateCompatibleDC()   
saveBitMap = win32ui.CreateBitmap()   
MoniterDev=win32api.EnumDisplayMonitors(None,None)  

#print w,h　　　＃图片大小  
w = MoniterDev[0][2][2]  
h = MoniterDev[0][2][3]  
saveBitMap.CreateCompatibleBitmap(mfcDC, w, h)   
saveDC.SelectObject(saveBitMap)   
saveDC.BitBlt((0,0),(w, h) , mfcDC, (0,0), win32con.SRCCOPY)  
bmpname = "grab_win32_demo.bmp"
saveBitMap.SaveBitmapFile(saveDC, bmpname)  
Image.open(bmpname).save(bmpname[:-4]+".png") 
