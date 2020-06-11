# encoding: UTF8
from enebootools.autoconfig.autoconfig import AutoConfigTemplate, ConfigReader
from enebootools import CONF_DIR
import sys, os.path


class FeatureConfig(AutoConfigTemplate):
    """
    name=string:extName
    code=string:ext9999
    description=string:long description
    type=string:ext
    """
    

def loadFeatureConfig(filename, saveTemplate = False):
    files = [ filename ]
    last_file = files[-1]
    if saveTemplate == "*template*":
        saveTemplate = last_file + ".template"
        files = []
    elif saveTemplate == "*update*":
        saveTemplate = last_file
    elif not os.path.exists(last_file):
        files = []
        saveTemplate = last_file
    
    cfg = ConfigReader(files=files, saveConfig = saveTemplate)
    cfg.feature = FeatureConfig(cfg,section = "feature")
    
    if saveTemplate:
        f1w = open(saveTemplate, 'wb')
        cfg.configini.write(f1w)
        f1w.close()
    return cfg


def main():
    filename = sys.argv[1]
    if len(sys.argv) > 2:
        if sys.argv[2] == 'savetemplate':
            reloadConfig(filename, saveTemplate = '*template*')
        elif sys.argv[2] == 'update':
            reloadConfig(filename, saveTemplate = '*update*')
    else:
        reloadConfig(filename)


if __name__ == "__main__": main()
