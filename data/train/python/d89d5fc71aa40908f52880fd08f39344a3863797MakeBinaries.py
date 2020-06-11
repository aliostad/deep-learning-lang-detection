# -*- coding: utf-8 -*-
"""
Created on Wed Nov 30 16:37:44 2016

@author: Yara
"""

import os
import pandas as pd
import numpy as np

def FindPath(FolderName='RawDataCSVs'):
    cur_dir= os.getcwd()
    while True :
        file_list= os.listdir(cur_dir)
        parent_dir = os.path.dirname(cur_dir)
        if FolderName in file_list:
            path= cur_dir + os.sep + FolderName
            break
        else:
            if cur_dir == parent_dir: #if dir is root dir
                print( "File not found, make sure your directory is not too wide...It would be preferred if you were in the repo ")
                break
            else:
                cur_dir = parent_dir
    return path

def Alliance(RawDataPath=[], Save= False, SavePath=[] ):
    if not RawDataPath:
        RawDataPath= FindPath()
    path_alliance= RawDataPath + os.sep +"alliance.csv"
    alliance=pd.read_csv(path_alliance ) #loading csv of all the data for all the years for that layer

    data=alliance[alliance.RelativeCommitment > -1]

    columns00length= len(alliance[alliance['country1.1'] > -1])
    temp= np.array([alliance['country1.1'], alliance['country2.1'],alliance['Year.1'],alliance['RelativeCommitment.1'] ]).T
    mat2= temp[0:columns00length , :]

    mat1= np.array([data.country1, data.country2, data.Year, data.RelativeCommitment]).T

    mat2= np.array(mat2, dtype= np.int32)
    mat1= np.array(mat1, dtype=np.int32)

    alliancearray= np.vstack([mat1,mat2])

    if Save is True:
        if not SavePath:
            curr_dir= os.getcwd()
            SavePath = curr_dir + os.sep +'Alliance'
        else:
            SavePath= SavePath + os.sep+'Alliance'
        np.save(SavePath, alliancearray)
    return alliancearray

def Conflict(RawDataPath=[], Save= False, SavePath=[] ):
    if not RawDataPath:
        RawDataPath= FindPath()
    path_conflict= RawDataPath + os.sep+"conflict.csv"
    conflict=pd.read_csv(path_conflict ) #loading csv of all the data for all the years for that layer

    data=conflict[conflict.Conflict >= 0] #removing redundant conflict ratings

    columns00length= len(conflict[conflict['country1.1']> 0]) #defines the number of cells full in that part of the dict
    temp= np.array([conflict['country1.1'], conflict['country2.1'],conflict['Year.1'],conflict['Conflict.1'] ]).T
    mat2= temp[0:columns00length , :] #reducing the matrix from columns 4-8 with that data to their real size


    mat1= np.array([data.country1, data.country2, data.Year, data.Conflict]).T

    mat2= np.array(mat2, dtype= np.int32) #faster and better for memory
    mat1= np.array(mat1, dtype=np.int32)
    #concatenating matrix with data from 1948-1999 and 2000-2001
    conarray= np.vstack([mat1,mat2])
    if Save is True:
        if not SavePath:
            curr_dir= os.getcwd()
            SavePath = curr_dir + os.sep+ 'Conflict'
        else:
            SavePath= SavePath + os.sep +'Conflict'
        np.save(SavePath, conarray)
    return conarray

def Trade(RawDataPath=[], Save= False, SavePath=[] ):
    if not RawDataPath:
        RawDataPath= FindPath()
    path_trade= RawDataPath + os.sep +"trade.csv"
    data=pd.read_csv(path_trade)


    mat1= np.array([data.country1, data.country2, data.Year, data.Dependence]).T
    mat1= np.array(mat1, dtype=np.float)
    if Save is True:
        if not SavePath:
            curr_dir= os.getcwd()
            SavePath = curr_dir + os.sep + 'Trade'
        else:
            SavePath= SavePath + os.sep + 'Trade'
        np.save(SavePath, mat1)
    return mat1

def NCA(RawDataPath=[], Save= False, SavePath=[] ):
    if not RawDataPath:
        RawDataPath= FindPath()
    path_NCA= RawDataPath + os.sep + "fixedNCA.csv"
    NCA=pd.read_csv(path_NCA)

    data=NCA[NCA.Aggregated>= 0]

    mat1= np.array([data.country1, data.country2, data.Year, data.Aggregated]).T
    mat1= np.array(mat1, dtype=np.int32)
    if Save is True:
        if not SavePath:
            curr_dir= os.getcwd()
            SavePath = curr_dir + os.sep + 'NCA'
        else:
            SavePath= SavePath + os.sep + 'NCA'
        np.save(SavePath, mat1)
    return mat1

def MS(RawDataPath=[], Save= False, SavePath=[]):
    if not RawDataPath:
        RawDataPath= FindPath()
    path_MC=  RawDataPath + os.sep + "MilitaryStrength.csv"
    MC=pd.read_csv(path_MC)

    data=MC[MC.CINC>= 0]


    mat1= np.array([data.Country, data.Year, data.CINC]).T
    mat1= np.array(mat1, dtype=np.float)
    if Save is True:
        if not SavePath:
            curr_dir= os.getcwd()
            SavePath = curr_dir + os.sep + 'MilitaryStrength'
        else:
            SavePath= SavePath + os.sep + 'MilitaryStrength'
        np.save(SavePath, mat1)
    return mat1

def NC(RawDataPath=[], Save= False, SavePath=[]):
    if not RawDataPath:
        RawDataPath= FindPath()
    path_NC=  RawDataPath + os.sep + "nuclearcapability.csv"
    NC=pd.read_csv(path_NC)
    data=NC[NC.NC>= 0]

    mat1= np.array([data.Country, data.Year, data.NC]).T
    mat1= np.array(mat1, dtype=np.int32)
    if Save is True:
        if not SavePath:
            curr_dir= os.getcwd()
            SavePath = curr_dir + os.sep + 'NuclearCapability'
        else:
            SavePath= SavePath + os.sep + 'NuclearCapability'
        np.save(SavePath, mat1)
    return mat1

def Countrykey(RawDataPath=[], Save= False, SavePath=[]):
    if not RawDataPath:
        RawDataPath= FindPath()
    path= RawDataPath + os.sep + "countrykey.csv"
    data= pd.read_csv(path)

    array= np.array([data.Country,data.Name])
    array= array.T
    if Save is True:
        if not SavePath:
            curr_dir= os.getcwd()
            SavePath = curr_dir + os.sep + 'CountryKey'
        else:
            SavePath= SavePath + os.sep + 'CountryKey'
        np.save(SavePath, array)
    return array

def All(RawDataPath= [],FolderName= 'RawDataCSVs', Save= False, SavePath=[]):
    if not RawDataPath:
        RawDataPath= FindPath()
    nc=NC(RawDataPath, Save=Save, SavePath=SavePath)
    ms=MS(RawDataPath, Save=Save, SavePath=SavePath)
    al= Alliance(RawDataPath, Save=Save, SavePath=SavePath)
    tr= Trade(RawDataPath, Save=Save, SavePath=SavePath)
    conf= Conflict(RawDataPath, Save=Save, SavePath=SavePath)
    nca= NCA(RawDataPath, Save=Save, SavePath=SavePath)
    countrykey= Countrykey(RawDataPath, Save=Save, SavePath=SavePath)
    return (al,tr,conf,nca,nc,ms,countrykey)

def SaveBinaries(FolderPath):
    MakeBinaries(Save= True, SavePath= FolderPath)


