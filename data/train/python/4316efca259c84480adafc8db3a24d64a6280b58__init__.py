# -*- coding:utf-8 -*-
# !/usr/bin/env python
#
# Author: Leann Mak
# Email: leannmak@139.com
#
# This is the init file defining api with urls for the cmdb package.
#
from .hostgroupapi import HostGroupListAPI, HostGroupAPI
from .hostapi import HostListAPI, HostAPI
# from .host import HostAPI
from .. import api

api.add_resource(
    HostGroupListAPI, '/api/v0.0/hostgroup', endpoint='hostgroup_list_ep')
api.add_resource(
    HostGroupAPI, '/api/v0.0/hostgroup', endpoint='hostgroup_ep')
api.add_resource(
    HostGroupAPI, '/api/v0.0/hostgroup/<groupid>', endpoint='hostgroup_id_ep')
api.add_resource(
    HostListAPI, '/api/v0.0/host', endpoint='host_list_ep')
api.add_resource(
    HostAPI, '/api/v0.0/host/<hostid>', endpoint='host_id_ep')
