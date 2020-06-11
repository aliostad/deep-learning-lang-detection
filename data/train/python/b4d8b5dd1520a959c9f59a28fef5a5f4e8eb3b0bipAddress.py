#!/usr/bin/env python
# -*- coding=utf-8 -*-
import requests
import json

QUERY_URL = "http://restapi.amap.com/v3/ip?key=edbf54692367e49ce8069db925057b77&ip=" #高德API

def ipAddress(ip, save_dict):
	if not all((ip, save_dict)) or not isinstance(save_dict, dict):
		save_dict['area'] = "未知"
		return
	url = QUERY_URL + ip;
	try:
		result = requests.get(url, timeout=0.4)
		ret_json = result.json()
		if ret_json['status'] == '1':
			save_dict['area'] = (ret_json["city"] and [ret_json["province"] + '-' + ret_json["city"],] or [ret_json["province"],])[0]
		else:
			save_dict['area'] = "未知"
	except Exception, e:
		save_dict['area'] = "未知"
		print e
	

if __name__ == '__main__':
	save_dict = {}
	ipAddress("180.97.83.70", save_dict)
	print save_dict
	print save_dict['area']
