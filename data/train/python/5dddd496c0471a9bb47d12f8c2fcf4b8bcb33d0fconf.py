#!/usr/bin/env python
# -*- coding: utf-8 -*-

import etc

host_name = 'shitouren'
domain_name = host_name+'.com'
pfx = 'lohas'
img_limit = 9

url = {
    'img_default'        : '/img/lohas/nopic_400.png',
    'http_moai'          : 'http://moai.shitouren.com',
    'guest_main'         : r"/" ,
    'guest_items'        : r"/items" ,
    'guest_index'        : r"/index" ,
    'guest_signout'      : r"/signout" ,
    'guest_findpwd'      : r"/findpwd" ,
    'guest_resetpwd'     : r"/resetpwd" ,
    'host_home'          : r"/home" ,
    'host_admin'         : r"/admin" ,
    'host_app'           : r"/admin/app" ,
    'host_stat'          : r"/admin/stat" ,
    'host_appadd'        : r"/admin/appadd" ,
    'host_profile'       : r"/admin/profile" ,
    'host_nodeinfo'      : r"/admin/nodeinfo" ,
    'host_node'          : r"/admin/node" ,
    'api_signin'         : r"/api/signin" ,
    'api_signout'        : r"/api/signout" ,
    'api_signup'         : r"/api/signup" ,
    'api_findpwd'        : r"/api/findpwd" ,
    'api_resetpwd'       : r"/api/resetpwd" ,
    'api_emailedit'      : r"/api/emailedit",
    'api_pwdedit'        : r"/api/pwdedit",
    'api_phoneedit'      : r"/api/phoneedit",
    'api_appadd'         : r"/api/appadd" ,
    'api_appupdate'      : r"/api/appupdate" ,
    'api_appdeactive'    : r"/api/appdeactive" ,
    'api_nodeadd'        : r"/api/nodeadd" ,
    'api_nodedel'        : r"/api/nodedel" ,
    'api_nodeupdate'     : r"/api/nodeupdate" ,
    'api_nodesort'       : r"/api/nodesort" ,
    'api_nodeimgupdate'  : r"/api/nodeimgupdate" ,
    'api_nodeimgadd'     : r"/api/nodeimgadd" ,
    'api_nodeimgdel'     : r"/api/nodeimgdel" ,
    'api_stat'           : r"/api/stat" ,
    'api_click'          : r"/api/click" ,
    'api_link'           : r"/api/link" ,
    'api_items'          : r"/api/items" ,
    'api_appdel'         : r"/api/appdel" ,
}

msg = {
    'err_500'           : etc.err_500,
    'err_timeout'       : etc.err_timeout,
    'err_op'            : etc.err_op,
    'st_app_keys'       : ['浏览次数','弹层次数','进入'],
    'st_node_keys'      : ['弹层','进入'],
    'st_hour_labels'    : ['0时','1时','2时','3时','4时','5时','6时','7时','8时','9时','10时','11时','12时','13时','14时','15时','16时','17时','18时','19时','20时','21时','22时','23时'],
    'st_month_labels'   : ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
}

key_appseq   = 'appid'
key_nodeseq  = 'nodeid'

