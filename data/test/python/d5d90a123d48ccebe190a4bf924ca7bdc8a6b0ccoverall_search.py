#!/usr/local/bin/python

import importme
from cgihandler import cgi_fcgi
from cgibase import ActionManageBase
from equipquery import OverallSearchRole, OverallSearchPet, OverallSearchEquip,\
		OverallSearchDaoju

class ActionManage(ActionManageBase):
	def __init__(self):
		super(ActionManage, self).__init__()
		self._action_mapping = {
			"overall_search_role": OverallSearchRole,
			"overall_search_pet": OverallSearchPet,
			"overall_search_equip": OverallSearchEquip,
			"overall_search_daoju" : OverallSearchDaoju,
		}

if __name__ == "__main__":
	cgi_fcgi.AcceptAndHandle(ActionManage)
