/*
* Copyright (c) 2010 Nokia Corporation and/or its subsidiary(-ies). 
* All rights reserved.
* This component and the accompanying materials are made available
* under the terms of "Eclipse Public License v1.0"
* which accompanies this distribution, and is available
* at the URL "http://www.eclipse.org/legal/epl-v10.html".
*
* Initial Contributors:
* Nokia Corporation - initial contribution.
*
* Contributors:
*
* Description:   VideoCollectionWrapper class implementation
* 
*/

#include "videocollectionwrapper.h"
#include "videocollectionwrapperdata.h"
/*
bool VideoCollectionWrapperData::mGetGenericModelFails = false;
bool VideoCollectionWrapperData::mGetAllVideosModelFails = false;
bool VideoCollectionWrapperData::mGetCollectionsModelFails = false;
bool VideoCollectionWrapperData::mGetCollectionContentModelFails = false;
VideoListDataModel *VideoCollectionWrapperData::mSourceModel = 0;
QPointer<VideoProxyModelGeneric> VideoCollectionWrapperData::mAllVideosModel = 0;
QPointer<VideoProxyModelGeneric> VideoCollectionWrapperData::mCollectionsModel = 0;
QPointer<VideoProxyModelGeneric> VideoCollectionWrapperData::mCollectionContentModel = 0;
QPointer<VideoProxyModelGeneric> VideoCollectionWrapperData::mGenericModel = 0;*/

VideoCollectionWrapper &VideoCollectionWrapper::instance()
{
    static VideoCollectionWrapper _staticWrapper;
    return _staticWrapper;
}

VideoCollectionWrapper::VideoCollectionWrapper() 
{
    // nop
}

VideoCollectionWrapper::~VideoCollectionWrapper()
{
    VideoCollectionWrapperData::reset();
}

VideoProxyModelGeneric* VideoCollectionWrapper::getGenericModel()
{
    VideoProxyModelGeneric *model = 0;
    if (!VideoCollectionWrapperData::mGetGenericModelFails)
    {
        VideoListDataModel *sourceModel = VideoCollectionWrapperData::mSourceModel;
        if (!sourceModel)
        {
            sourceModel = new VideoListDataModel;
            sourceModel->initialize();
            VideoCollectionWrapperData::mSourceModel = sourceModel;
        }

        model = VideoCollectionWrapperData::mGenericModel;
        if(!model && VideoCollectionWrapperData::mSourceModel)
        {
            model = new VideoProxyModelGeneric();
            model->initialize(VideoCollectionWrapperData::mSourceModel);
            VideoCollectionWrapperData::mGenericModel = model;
        }
    }
    
    return model;
}

VideoProxyModelGeneric* VideoCollectionWrapper::getAllVideosModel()
{
    VideoProxyModelGeneric *model = 0;
    if (!VideoCollectionWrapperData::mGetAllVideosModelFails)
    {
        VideoListDataModel *sourceModel = VideoCollectionWrapperData::mSourceModel;
        if (!sourceModel)
        {
            sourceModel = new VideoListDataModel;
            sourceModel->initialize();
            VideoCollectionWrapperData::mSourceModel = sourceModel;
        }

        model = VideoCollectionWrapperData::mAllVideosModel;
        if (!model)
        {
            model = new VideoProxyModelAllVideos();
                model->initialize(VideoCollectionWrapperData::mSourceModel);
            VideoCollectionWrapperData::mAllVideosModel = model;
        }
    }
    
    return model;
}

VideoProxyModelGeneric* VideoCollectionWrapper::getCollectionsModel()
{
    VideoProxyModelGeneric *model = 0;
    if (!VideoCollectionWrapperData::mGetCollectionsModelFails)
    {
        VideoListDataModel *sourceModel = VideoCollectionWrapperData::mSourceModel;
        if (!sourceModel)
        {
            sourceModel = new VideoListDataModel;
            sourceModel->initialize();
            VideoCollectionWrapperData::mSourceModel = sourceModel;
        }

        model = VideoCollectionWrapperData::mCollectionsModel;
        if (!model)
        {
            model = new VideoProxyModelCollections();
            model->initialize(VideoCollectionWrapperData::mSourceModel);
            VideoCollectionWrapperData::mCollectionsModel = model;
        }
    }
    
    return model;
}

VideoProxyModelGeneric* VideoCollectionWrapper::getCollectionContentModel()
{
    VideoProxyModelGeneric *model = 0;
    if (!VideoCollectionWrapperData::mGetCollectionContentModelFails)
    {
        VideoListDataModel *sourceModel = VideoCollectionWrapperData::mSourceModel;
        if (!sourceModel)
        {
            sourceModel = new VideoListDataModel;
            sourceModel->initialize();
            VideoCollectionWrapperData::mSourceModel = sourceModel;
        }

        model = VideoCollectionWrapperData::mCollectionContentModel;
        if (!model)
        {
            model = new VideoProxyModelContent();
            model->initialize(VideoCollectionWrapperData::mSourceModel);
            VideoCollectionWrapperData::mCollectionContentModel = model;
        }
    }
    
    return model;
}

void VideoCollectionWrapper::sendAsyncStatus(int statusCode,
    QVariant &additional)
{
    Q_UNUSED(statusCode);
    Q_UNUSED(additional);
    // not stubbed
}

// end of file
