# Copyright 2012 Beixinyuan(Nanjing), All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.


__author__ = 'tangjun'
__date__ = '2013-04-01'
__version__ = 'v2.0.5'


from django.utils.importlib import import_module
import sys
reload(sys)
sys.setdefaultencoding('utf8')

def parse_log(logs_path):

    _log_key_name = 'logs_information'

    try:
        if isinstance(logs_path, basestring):
            logs_module = import_module(logs_path)

        logs_information = getattr(logs_module, _log_key_name, None)

        return logs_information
    except Exception, e:
        return None


log_informations = [
    # add logs configuration here
    parse_log('dashboard.control_manage.logs'),
    parse_log('dashboard.software_manage.logs'),
    parse_log('dashboard.authorize_manage.logs'),
    parse_log('dashboard.instance_manage.logs'),
    parse_log('dashboard.securitygroup_manage.logs'),
    parse_log('dashboard.project_manage.logs'),
    parse_log('dashboard.notice_manage.logs'),
    parse_log('dashboard.node_manage.logs'),
    parse_log('dashboard.image_template_manage.logs'),
    parse_log('dashboard.hard_template_manage.logs'),
    parse_log('dashboard.user_manage.logs'),
    parse_log('dashboard.volume_manage.logs'),
    parse_log('dashboard.thresholds_manage.logs'),
    parse_log('dashboard.virtual_address_manage.logs'),
    parse_log('dashboard.virtual_network_manage.logs'),
    parse_log('dashboard.virtual_router_manage.logs'),
#    parse_log('dashboard.virtual_keypairs_manage.logs'),

]

def generate_informations(log_informations=log_informations):

    log_infos = {}
    for log in log_informations:
        if None != log and isinstance(log, list):
            for info in log:
                if None != info and isinstance(info, list) and len(info) >= 1:
                    log_infos[info[0]]=info
    return log_infos

