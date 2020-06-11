 
package com.mini.mn.network.socket;

import android.os.Handler;

/**
 * 消息处理，用于ui线程处理消息事件
 * 
 * @version 1.0.0
 * @date 2014-2-13
 * @author S.Kei.Cheung
 */
public abstract class MessageEventHandlerContainer {

	/** 消息接收Handler */
	protected Handler messageReceivedHandler;

	/** 回复接收Handler */
	protected Handler replyReceivedHandler;

	/** 成功发送消息Handler */
	protected Handler messageSentSuccessfulHandler;

	/** 错误捕捉Handler */
	protected Handler exceptionCaughtHandler;

	/** Session关闭Handler */
	protected Handler sessionClosedHandler;

	/** Session创建Handler */
	protected Handler sessionCreatedHandler;

	/** 消息发送失败Handler */
	protected Handler messageSentFailedHandler;

	/** 连接失败Handler */
	protected Handler connectionFailedHandler;
	
	/** 网络改变Handler */
	protected Handler networkChangedHandler;

	/** 创建消息接收Handler */
	public abstract void createMessageReceivedHandler();

	/** 创建连接失败Handler */
	public abstract void createConnectionFailedHandler();

	/** 创建回复接收Handler */
	public abstract void createReplyReceivedHandler();

	/** 创建消息成功发送Handler */
	public abstract void createMessageSentSuccessfulHandler();

	/** 创建错误捕捉Handler */
	public abstract void createExceptionCaughtHandler();

	/** 创建Session关闭Handler */
	public abstract void createSessionClosedHandler();

	/** 创建Session创建Handler */
	public abstract void createSessionCreatedHandler();

	/** 创建消息发送失败Handler */
	public abstract void createMessageSentFailedHandler();
	

}
