#!/usr/bin/python3

import os
import glob
import subprocess
import optparse

def find_faces(imgDir, facemodelFile, posemodelFile, imgSaveDir, xmlSaveDir): 
    imgDir = os.path.expanduser(imgDir)
    if imgSaveDir!="-":
        imgSaveDir = os.path.expanduser(imgSaveDir)
        if not os.path.exists(imgSaveDir):
            os.makedirs(imgSaveDir)
    if xmlSaveDir!="-":
    	xmlSaveDir = os.path.expanduser(xmlSaveDir)
    	if not os.path.exists(xmlSaveDir): 
            os.makedirs(xmlSaveDir)
    imgs = glob.glob(os.path.join(imgDir,"*.jpg"))
    for i,img in enumerate(imgs):
        print("Processing {0}/{1}: {2}".format(i+1,len(imgs),img))
        imgName = os.path.splitext(os.path.basename(img))[0];
        if imgSaveDir=="-": 
            imgSaveName="-"
        else: 
            imgSaveName = os.path.join(imgSaveDir,imgName+".jpg")
        if xmlSaveDir=="-":
            xmlSaveName="-"
        else:
            xmlSaveName = os.path.join(xmlSaveDir,imgName+".xml")
        subprocess.call(["./facefinder",img,facemodelFile,posemodelFile,imgSaveName,xmlSaveName])
        
def main():
    usage = "usage: %prog [options] IMAGE_DIR SAVE_DIR"
    parser = optparse.OptionParser(usage)
    parser.add_option("-f","--facemodel",dest="facemodel",metavar="FACE_MODEL")
    parser.add_option("-p","--posemodel",dest="posemodel",metavar="POSE_MODEL",default="-")
    parser.add_option("-i","--saveimg",action="store_true",dest="saveimg",default=False)
    parser.add_option("-x","--savexml",action="store_true",dest="savexml",default=False)
    (options,args) = parser.parse_args()
    if options.saveimg: 
        imgSaveDir = args[1]
    else:
        imgSaveDir = "-"
    if options.savexml:
        xmlSaveDir = args[1]
    else:
        xmlSaveDir = "-"
    find_faces(args[0],options.facemodel,options.posemodel,imgSaveDir,xmlSaveDir)

if __name__ == '__main__': 
    main()
