from django.conf import settings
from api.models import ApiKey

import evelink

def verify_access_mask(api):
	account = evelink.account.Account(api=api)
	key_info = account.key_info()
	result = settings.ACCESS_MASK - (settings.ACCESS_MASK & key_info['access_mask'])
	if result > 0:
    	return True
	else:
    	return False

def api_link_from_model(api_model):
	return evelink.api.API(api_key=(api_model.keyid, api_model.vcode))

def api_link_from_key(keyid, vcode):
	return evelink.api.API(api_key=(keyid, vcode))

def add_key(user, keyid, vcode, primary_api_key=True):
	key = ApiKey()
    key.user = models.ForeignKey(User)
    key.userid = keyid
    key.vcode = vcode
	api = api_link_from_key(keyid, vcode)
    key.valid = verify_access_mask(api)

    key.primary_api_key = primary_api_key