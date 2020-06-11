//
//  ResourceAsyncLoadTask.cpp
//  poker
//
//  Created by xiaoxiangzi on 13-12-13.
//
//

#include "ResourceAsyncLoadTask.h"
#include "ResourceConfigCache.h"
#include "FileCache.h"
#include "ResourceKey.h"
#include "ResourceManager.h"
using namespace std;

ResourceAsyncLoadTask* ResourceAsyncLoadTask::create() {
    ResourceAsyncLoadTask* task = new ResourceAsyncLoadTask;
    task->autorelease();
    return task;
}

ResourceAsyncLoadTask::ResourceAsyncLoadTask() :
_target(NULL),
_selector(NULL),
_cache(NULL),
_hasFinished(true),
_hasLoadVideoStarted(false),
_hasLoadImageStarted(false),
_hasLoadPlistStarted(false),
_hasLoadAudioStarted(false),
_resKey(NULL) {
    CC_SAFE_RELEASE_NULL(_resKey);
}

void ResourceAsyncLoadTask::loadResAsync(const ResourceConfigCache *cache, cocos2d::CCObject *target, SEL_CallFuncO selector, ResourceKey* resKey) {
    _cache = cache;
    _target = target;
    _selector = selector;
    _hasFinished = false;
    _resKey = resKey;
    CC_SAFE_RETAIN(_resKey);
}

void ResourceAsyncLoadTask::initLoadImages() {
    const map<ImageId, RImageConfig>& imagesConfig = _cache->getImagesConfig();
    _imagesToLoad.clear();
    for (auto iter = imagesConfig.begin(); iter != imagesConfig.end(); iter++) {
        const RImageConfig* config = &iter->second;
        _imagesToLoad.push_back(config);
    }
}

void ResourceAsyncLoadTask::initLoadVideos() {
    const map<VideoId, RVideoConfig>& videosConfig = _cache->getVideosConfig();
    _videosToLoad.clear();
    for (auto iter = videosConfig.begin(); iter != videosConfig.end(); iter++) {
        const RVideoConfig* config = &iter->second;
        _videosToLoad.push_back(config);
    }
}

void ResourceAsyncLoadTask::initLoadPlists() {
    const map<PlistId, RPlistConfig>& plistsConfig = _cache->getPlistsConfig();
    _plistsToLoad.clear();
    for (auto iter = plistsConfig.begin(); iter != plistsConfig.end(); iter++) {
        const RPlistConfig* config = &iter->second;
        _plistsToLoad.push_back(config);
    }
}

void ResourceAsyncLoadTask::initLoadAudios() {
    const map<AudioId, RAudioConfig>& audiosConfig = _cache->getAudiosConfig();
    _audiosToLoad.clear();
    for (auto iter = audiosConfig.begin(); iter != audiosConfig.end(); iter++) {
        const RAudioConfig* config = &iter->second;
        _audiosToLoad.push_back(config);
    }
}

void ResourceAsyncLoadTask::loadImage() {
    if (_imagesToLoad.empty()) {
        return;
    }
    
    const RImageConfig* config = _imagesToLoad.back();
    _imagesToLoad.pop_back();
    ResourceManager::getInstance()->bindKeyToResource(config->getImageId(), _resKey, ResourceManager::IMAGE_CONFIG);
}

void ResourceAsyncLoadTask::loadVideo() {
    if (_videosToLoad.empty()) {
        return;
    }
    
    const RVideoConfig* config = _videosToLoad.back();
    _videosToLoad.pop_back();
    ResourceManager::getInstance()->bindKeyToResource(config->getVideoId(), _resKey, ResourceManager::VIDEO_CONFIG);
}

void ResourceAsyncLoadTask::loadAudio() {
    if (_audiosToLoad.empty()) {
        return;
    }
    
    const RAudioConfig* config = _audiosToLoad.back();
    _audiosToLoad.pop_back();
    ResourceManager::getInstance()->bindKeyToResource(config->getAudioId(), _resKey, ResourceManager::AUDIO_CONFIG);
}

void ResourceAsyncLoadTask::loadPlist() {
    if (_plistsToLoad.empty()) {
        return;
    }
    
    const RPlistConfig* config = _plistsToLoad.back();
    _plistsToLoad.pop_back();
    ResourceManager::getInstance()->loadPlistResource(config->getPlistId(), _resKey);
}

bool ResourceAsyncLoadTask::hasTaskFinished() const {
    return _hasFinished;
}

void ResourceAsyncLoadTask::update() {
    if (_hasFinished) {
        return;
    }
    
    // step1. 先加载图片
    if (!_hasLoadImageStarted) {
        initLoadImages();
        _hasLoadImageStarted = true;
    }
    
    loadImage();
    
    if (_imagesToLoad.size() > 0) {
        return;
    }
    
    // step2. 再加载视频。图片和视频分两步异步加载是为了避免CCFileUtils里面的异步不安全问题
    if (!_hasLoadVideoStarted) {
        initLoadVideos();
        _hasLoadVideoStarted = true;
    }
    
    loadVideo();
    
    if (_videosToLoad.size() > 0) {
        return;
    }
    
    if (!_hasLoadPlistStarted) {
        initLoadPlists();
        _hasLoadPlistStarted = true;
    }
    
    loadPlist();
    
    if (_plistsToLoad.size() > 0) {
        return;
    }
    
    if (!_hasLoadAudioStarted) {
        initLoadAudios();
        _hasLoadAudioStarted = true;
    }
    
    loadAudio();
    
    if (_audiosToLoad.size() > 0) {
        return;
    }
    
    if (_target && _selector) {
        (_target->*_selector)(NULL);
    }
    _hasFinished = true;
}

ResourceKey* ResourceAsyncLoadTask::getResourceKey() {
    return _resKey;
}

void ResourceAsyncLoadTask::cancelTask() {
    _hasFinished = true;
}
