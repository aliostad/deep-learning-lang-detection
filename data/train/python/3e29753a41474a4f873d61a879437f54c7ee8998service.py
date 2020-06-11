# -*- encoding: utf-8 -*-
'''
Created on 2014年11月12日

@author: huangtx
'''
import os, sys
from globalVars import *
# from wxLib.controller.schedule_controller import *

execfile(os.path.dirname(__file__) + "\\wxLib\\controller\\weixin_controller.py")
execfile(os.path.dirname(__file__) + "\\wxLib\\controller\\vote_controller.py")
execfile(os.path.dirname(__file__) + "\\wxLib\\controller\\theme_controller.py")
execfile(os.path.dirname(__file__) + "\\wxLib\\controller\\qy_weixin_config_controller.py")
execfile(os.path.dirname(__file__) + "\\wxLib\\controller\\zp_controller.py")

# while True:
#     schedule.run_pending()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8088, debug=True)