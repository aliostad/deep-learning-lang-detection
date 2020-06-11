#!/usr/bin/python
#-*-coding:utf-8-*-

import os
import sys

from get_opt import GetOpt
from cmd_controller import CmdController
from gui_controller import GuiController

# 命令参数化 --cmd命令行模式
# gui参数   --gui命令行模式
def usage():
    return "usage:%s%s%s%s" %("[--cmd] 命令行模式\n",
                              "[--gui] 图形化模式\n",
                              "[-h] 帮助\n",
                              "[--help] 帮助\n")

def main(script, *args):
    opt_args = GetOpt.get_opt(usage())

    mode = "gui"
    if opt_args.has_key("--cmd"):
        mode = "cmd"

    controller = None
    if "gui" == mode:
        controller = GuiController()
    else:
        controller = CmdController()
    controller.run()

if __name__ == "__main__":
    import sys
    reload(sys)
    sys.setdefaultencoding('utf-8')

    main(*sys.argv)
