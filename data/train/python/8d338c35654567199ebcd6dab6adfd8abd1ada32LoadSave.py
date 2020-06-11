# -*- coding: utf-8 -*-
__author__ = 'VasiliyRusin'

from tkinter.filedialog import *
from tkinter import Tk

""" """

class LoadSave():
    def __init__(self):
        self.root = Tk().withdraw()
        self.openPath = '-1'
        self.savePath = '-1'

    def openFile(self):# Открыть файл
        self.openPath = askopenfilename()

    def saveFile(self):# Сохранить файл
        self.savePath = asksaveasfilename()

    def getOpenPath(self):# Получить путь до открытого файла
        return self.openPath

    def getSavePath(self):# Получить путь до сохраненного файла
        return self.savePath
