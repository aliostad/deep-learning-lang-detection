# -*- coding: utf-8 -*-

__author__ = 'Wang Chao'
__date__ = '4/3/14'

from functools import partial
from django.conf import settings

from libs.apiclient import APIFailure, HTTPAPIClient, HTTPSAPIClient

HUB_URL = "https://{0}:{1}".format(settings.HUB_HOST, settings.HUB_HTTPS_PORT)

HTTPSAPIClient.install_pem('/opt/ca/client.pem')
apicall = HTTPSAPIClient()

api_server_list = partial(apicall, cmd=HUB_URL + '/api/server-list/')
api_server_register = partial(apicall, cmd=HUB_URL + '/api/server-list/register/')

api_account_login = partial(apicall, cmd=HUB_URL + '/api/account/login/')
api_account_bind = partial(apicall, cmd=HUB_URL + '/api/account/bind/')
api_character_create = partial(apicall, cmd=HUB_URL + '/api/character/create/')
api_character_failure = partial(apicall, cmd=HUB_URL + '/api/character/failure/')

api_store_get = partial(apicall, cmd=HUB_URL + '/api/store/get/')
api_store_buy = partial(apicall, cmd=HUB_URL + '/api/store/buy/')

api_activatecode_use = partial(apicall, cmd=HUB_URL + '/api/activatecode/use/')

api_get_checkin_data = partial(apicall, cmd=HUB_URL + '/api/checkin/get/')

api_purchase_verify = partial(apicall, cmd=HUB_URL + '/api/purchase/verify/')
api_purchase_allsdk_verify = partial(apicall, cmd=HUB_URL + '/api/purchase/allsdk/verify/')

api_purchase_get_order_id = partial(apicall, cmd=HUB_URL + '/api/purchase/orderid/')
api_purchase91_confirm = partial(apicall, cmd=HUB_URL + '/api/purchase/91/confirm/')
api_purchase_aiyingyong_confirm = partial(apicall, cmd=HUB_URL + '/api/purchase/aiyingyong/confirm/')
api_purchase_jodoplay_confirm = partial(apicall, cmd=HUB_URL + '/api/purchase/jodoplay/confirm/')

api_system_broadcast_get = partial(apicall, cmd=HUB_URL + '/api/system/broadcast/')
