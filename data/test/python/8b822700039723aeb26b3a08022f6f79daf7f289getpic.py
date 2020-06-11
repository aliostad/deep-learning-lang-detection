# -*- coding:utf-8 -*-
import urllib
import os

def getimg(SavePath,i):
	SavePath=SavePath
	i=i
	i2=i+400
	while i<i2:
		print i
		url = "http://*****/ph/"+str(i)+".jpg" 
		if os.path.isdir(SavePath): 
			pass 
		else: 
			os.mkdir(SavePath)
		name=SavePath+str(i)+".jpg"
		f = open(name,'wb')
		f.write(urllib.urlopen(url).read())
		f.close()
		print('Pic Saved!') 
		i=i+1

if __name__=="__main__":
	
	yuanlist=['*']
	for yuan in yuanlist:
		banhao=['*']
		for  t in banhao:
			Path="./14"+yuan+t+'/'
		
			a="14"+yuan+t+"0001"
			a=int(a)
			getimg(Path,a)