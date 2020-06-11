#-*- coding: utf-8 -*-
__author__ = 'zhangjiangtao'
from selenium import webdriver
import time

def saveName(name):
    fp = "../result/image/"
    time = saveTime()
    pic_type = ".png"
    filename = str(fp)+str(name)+str("_")+str(time)+pic_type
    print filename
    return filename

def saveTime():
    #返回当前系统时间以括号中（2014-08-29-15_21_55）展示
    return time.strftime('%Y-%m-%d_%H_%M_%S')

def saveScreenshot(driver, name):
    image = driver.save_screenshot(saveName(name))
    return image
