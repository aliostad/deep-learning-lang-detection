/*
 *  jssdk_api.cpp
 *  Created on: Mar 31, 2016
 *
 *  Copyright (c) 2016 by Leo Hoo
 *  lion@9465.net
 */

#include "jssdk.h"
#include <string.h>

namespace js
{

const int32_t Api::version = 1;
Api* v8_api;
Api* spider_api;

bool set_js_api(Api*& api, Api* _api, const char* eng)
{
	if (strcmp(eng, _api->getEngine()) ||
	        Api::version != _api->getVersion())
		return false;

	api = _api;
	return true;
}

bool set_v8_api(Api* _api)
{
	return set_js_api(v8_api, _api, "v8");
}

bool set_spider_api(Api* _api)
{
	return set_js_api(spider_api, _api, "spider");
}

};