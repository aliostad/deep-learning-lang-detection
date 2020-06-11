/*
 *  EGRenderApi.cc
 *
 *  Copyright (c) 2008 - 2013, Michael Clark <michael@earthbuzz.com>, EarthBuzz Software
 */

#include "EG.h"
#include "EGGL.h"
#include "EGRenderApi.h"
#include "EGRenderApiES2.h"


/* EGRenderApi */

static const char class_name[] = "EGRenderApi";

EGRenderApi* EGRenderApi::currentApi = &EGRenderApiES2::apiImpl();

EGint EGRenderApi::nextApiId = 1;

EGRenderApi::EGRenderApi(const char* apiName, EGRenderApiVersion apiVersion) : apiId(nextApiId++), apiName(apiName), apiVersion(apiVersion) {}

EGRenderApi::~EGRenderApi() {}

const char* EGRenderApi::getName() const
{
    return apiName;
}

EGint EGRenderApi::getId() const
{
    return apiId;
}

EGRenderApiVersion EGRenderApi::getVersion() const
{
    return apiVersion;
}

EGbool EGRenderApi::isVersion(EGRenderApiVersion version) const
{
    return version == apiVersion;
}

EGRenderApi& EGRenderApi::currentApiImpl()
{
    return *currentApi;
}

EGbool EGRenderApi::init(EGRenderApi &api)
{
    EGDebug("%s:%s initializing %s\n", class_name, __func__, api.getName());
    return (currentApi = &api)->init();
}

EGbool EGRenderApi::initRenderApi(int glesVersion)
{
    // TODO change to enum
    switch (glesVersion) {
        case 2:
            if (!EGRenderApi::init(EGRenderApiES2::apiImpl())) {
                EGError("%s:%s could not initialize GLES20 renderer\n", class_name, __func__);
                return false;
            } else {
                return true;
            }
        default:
            EGError("%s:%s unknown renderer api version\n", class_name, __func__);
            return false;
    }
}
