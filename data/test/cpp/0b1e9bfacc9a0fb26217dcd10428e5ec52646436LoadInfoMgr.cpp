//
//  LoadInfoMgr.cpp
//  poker
//
//  Created by jayson on 13-12-26.
//
//

#include "LoadInfoMgr.h"
#include "Preferences.h"
#include "cocos2d.h"
#include "JSONUtil.h"
#include "Global.h"

USING_NS_CC;

string LoadInfoMgr::KEY_LOAD_INFO = "key_load_info";

void LoadInfo::parse(const JSONNode& param) {
    version = JSONUtil::getInt(param, "version");
    totalSize = JSONUtil::getInt(param, "totalSize");
    url = JSONUtil::getString(param, "url");
}

void LoadInfo::dumpLoadInfo(JSONNode& node) {
    node.push_back(JSONNode("url", url));
    node.push_back(JSONNode("version", version));
    node.push_back(JSONNode("totalSize", totalSize));
}

LoadInfoMgr::LoadInfoMgr() {
    init();
}

void LoadInfoMgr::setInfo(string url, double totalSize, int version) {
    LoadInfo newInfo;
    newInfo.url = url;
    newInfo.totalSize = totalSize;
    newInfo.version = version;
    _loadInfoMap[url] = newInfo;
    
    save();
}

LoadInfo LoadInfoMgr::getLoadInfo(string url) {
    if(_loadInfoMap.find(url) != _loadInfoMap.end()) {
        return _loadInfoMap[url];
    }
    LoadInfo info;
    return info;
}

bool LoadInfoMgr::isExist(string url) {
    return _loadInfoMap.find(url) != _loadInfoMap.end();
}

void LoadInfoMgr::remove(string url) {
    for(map<string, LoadInfo>::iterator iter = _loadInfoMap.begin(); iter != _loadInfoMap.end(); iter++) {
        if(iter->first == url) {
            _loadInfoMap.erase(iter);
            save();
            return;
        }
    }
}

void LoadInfoMgr::clear() {
    Preferences::sharedPreferences()->setStringForKey(KEY_LOAD_INFO.data(), "");
}


void LoadInfoMgr::init() {
#if CLEAR_LOCAL_VERSION_DATA
    clear();
#endif
    
    string loadinfo = Preferences::sharedPreferences()->getStringForKey(KEY_LOAD_INFO.data());
    CCLOG("[loadinfo] init : %s", loadinfo.c_str());
    if(loadinfo.size() <= 0) return;
    
    JSONNode node = libjson::parse(loadinfo);
    JSONNode::iterator iter = node.begin();
    while (iter != node.end()) {
        JSONNode targetNode = iter->as_node();
        
        LoadInfo loadInfo;
        loadInfo.parse(targetNode);

        _loadInfoMap.insert(pair<string, LoadInfo>(loadInfo.url,loadInfo));
        
        iter++;
    }
}

string LoadInfoMgr::dump() {
    JSONNode node(JSON_ARRAY) ;
    map<string,LoadInfo>::iterator iter = _loadInfoMap.begin();
    while(iter != _loadInfoMap.end()) {
        string key = iter->first;
        LoadInfo info = _loadInfoMap[key];
        
        JSONNode loadNode;
        info.dumpLoadInfo(loadNode);
        
        node.push_back(loadNode);
        iter++;
    }
    return node.write_formatted();
}

void LoadInfoMgr::save() {
    string data = dump();
    CCLOG("[loadinfo] save: %s", data.c_str());
    Preferences::sharedPreferences()->setStringForKey(KEY_LOAD_INFO.data(), data);
}