#!/usr/bin/python
# -*- coding:utf-8 -*-

__author__ = 'Ydface'

import gamestate
import cPickle
from util.macro import *
import equipment
import json
import session

save_obj = None
mysession = None

class Save(object):
    def __init__(self):
        super(Save, self).__init__()

    @staticmethod
    def save():
        sav_obj = dict()
        sav_obj["user"] = dict()
        sav_obj["bag"] = dict()
        sav_obj["skill"] = []

        player = gamestate.player

        sav_obj["user"] = player.user_serialize_save()
        sav_obj["item"] = player.item_serialize_save()
        sav_obj["equiped"] = player.equiped_serialize_save()

        j = json.dumps(sav_obj)

        out = open("save.sav", "wb")
        cPickle.dump(sav_obj, out)
        out.close()

        global mysession
        if not mysession:
            mysession = session.Session()
        result = mysession.save_exp(False, j)
        #mysession = None

    @staticmethod
    def init_save():
        global save_obj
        save_obj = dict()
        save_obj["user"] = dict()
        save_obj["bag"] = dict()

        user_obj = save_obj["user"]
        user_obj["level"] = 1
        user_obj["exp"] = 0

        save_obj["item"] = [None] * 90
        save_obj["equiped"] = [None] * 11

        equip = equipment.Equipment.create_equipment(1, 4, Quality_White, None)
        save_obj["equiped"][Equip_Left_Weapon] = equip.get_save()

    @staticmethod
    def load(module):
        global save_obj
        if not save_obj:
            try:
                file = open("save.sav")
                save_obj = cPickle.load(file)
                file.close()
            except IOError, e:
                Save.init_save()
        return save_obj[module]

