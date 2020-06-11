#pragma once
#include "BaseSceneLayer.h"
#include "resLoad\load\OnLoadListener.h"
#include "resLoad\FriendRes.h"
#include "resLoad/ResSingleton.h"
#include "utils\jishiqi.h"

//闪屏类，起始数据加载、起始资源加载、websocket网络连接，都应该在这里进行
class flashScene : public BaseSceneLayer, OnLoadListener
{
public :
	flashScene();
	~flashScene();

	static flashScene * createScene();

private:
	
	virtual void initData();
	virtual void initView();

	void connectCallBack(bool flag);//true 连接成功，false 连接失败

	virtual void OnLoadStart(LoadCount *loadCount) ;

	//加载进度，最大是1.0f,最小是0f，这个方法一定是在LoadStart和LoadComplete之间
	virtual void OnLoadProgress(LoadCount *loadCount, float progress);


	virtual void OnLoadComplete(LoadCount *loadCount);

	void updateFlashOver();
private:
	bool isConnectSuccess;
	bool isLoadStartResCompete;
	bool isLoadStartConfigCompete;

	CC_SYNTHESIZE_RETAIN(FriendRes *, mFriendRes, FriendRes);

	void jishicallback(jishiqi * g_jishiqi, jishiqi_type type)
	{}
};