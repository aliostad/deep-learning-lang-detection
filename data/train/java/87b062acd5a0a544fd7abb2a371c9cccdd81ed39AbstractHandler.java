package com.smikevon.chain;

/**
 * @description: 责任链模式，有多个对象，每个对象持有对下一个对象的引用，这样就会形成一条链，请求在这条链上传递，直到某一对象决定处理该请求。
 * 				 但是发出者并不清楚到底最终那个对象会处理该请求，所以，责任链模式可以实现，在隐瞒客户端的情况下，对系统进行动态的调整
 * @author     : fengxiao
 * @date       : 2014年10月28日 下午5:47:06
 */
public abstract class AbstractHandler implements Handler{
	private Handler handler;

	public Handler getHandler(){
		return handler;
	}

	public void setHandler(Handler handler){
		this.handler = handler;
	}
}
