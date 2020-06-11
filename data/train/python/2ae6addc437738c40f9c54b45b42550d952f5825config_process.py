#-*- coding:utf-8 -*-
'''
Author: liujingmin
'''
import re, os

from common.const import PROJECT


class ConfigProcess(object):
    def load(self):
        main_path = os.getcwd()
        config_path = os.path.join(main_path, "data")
        config_path = os.path.join(config_path, "config.txt")
        config_file = open(config_path, "r")
        for each in config_file.xreadlines():
            if re.match(r"^[pP][aA][tT][hH]:.*", each):
                save_path = each
            elif re.match(r"^[uU][rR][lL]:.*", each):
                url_path = each
        save_path = save_path[5:]
        while " " == save_path[0]:
            save_path = save_path[1:]
        url_path = url_path[4:]
        while " " == url_path[0]:
            url_path = url_path[1:]
        PROJECT.SavePath = save_path
        PROJECT.UrlPath = url_path

