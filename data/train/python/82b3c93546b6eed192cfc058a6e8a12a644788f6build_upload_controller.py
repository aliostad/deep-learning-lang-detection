
import sys
import os
from optparse import OptionParser
from tornado.template import Template
from build_template import *

def build_upload_controller(config, base_controller_name):
    config['controller_name'] += 'Controller'

    controller_name = config['controller_name']
    config['base_controller_name'] = base_controller_name

    path = os.path.join(config['product']['path'], "www\\controller", controller_name + ".php")
    controller_filename = path
    create_file_from_template("upload_controller.tpl.php", config, controller_filename)
    return controller_filename

def build_controller_by_config(config):
    controller_file = build_upload_controller(config, 'AbBaseController')
    return controller_file

def load_upload_config():
    parser = OptionParser()

    parser.add_option("-n", "--name", action="store",
                  dest="controller_name", help="Provide controller name")

    parser.add_option("-f", "--filename-pattern", action="store", default='',
                  dest="filename_pattern", help="Provide filename pattern")

    parser.add_option("-s", "--subdir-pattern", action="store",
                  dest="sub_dir_pattern", help="Provide sub dir pattern")

    parser.add_option("-c", "--config", action="store",
                  dest="config_file", help="Provide controller name")

    options, args = parser.parse_args()
    config = {}
    config_file = options.config_file
    if config_file is not None:
        with open(config_file, 'r') as f:
            content = f.read()
            config = json.loads(content)
        product_path = config['product']['path']
    return dict(config, **options.__dict__)

if __name__ == '__main__':
    # sys.argv = ['a.py', '--name=KxFileB', '--path=dir', '--filename-pattern={date[Y-m]}.{ext}', '--subdir-pattern={random[1,10]}', '--config=D:\\Projects\\AdminBuildr\\config\\config.json']
    config = load_upload_config()
    build_controller_by_config(config)

