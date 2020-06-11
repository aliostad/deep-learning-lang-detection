package com.application.base.redis.jedis.mq;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import redis.clients.jedis.JedisPubSub;

public class MsgHandler extends JedisPubSub {

	Logger logger = LoggerFactory.getLogger(MsgHandler.class);

	private Handler msgHandler;   //已发送消息
	
	private Handler subHandler;  //提交消息
	
	private Handler unSubHandler;  //未发送消息

	/**
	 * @param handler
	 *            消息处理接口
	 */
	public MsgHandler(Handler handler) {
		this.msgHandler = handler;
	}

	/**
	 * @param msgHandler
	 *            消息处理接口
	 * @param subHandler
	 *            订阅初始化接口
	 */
	public MsgHandler(Handler msgHandler, Handler subHandler) {
		this.msgHandler = msgHandler;
		this.subHandler = subHandler;
	}

	/**
	 * @param msgHandler
	 *            消息处理接口
	 * @param subHandler
	 *            订阅初始化接口
	 * @param unSubHandler
	 *            取消订阅接口
	 */
	public MsgHandler(Handler msgHandler, Handler subHandler, Handler unSubHandler) {
		this.msgHandler = msgHandler;
		this.subHandler = subHandler;
		this.unSubHandler = unSubHandler;
	}

	/**
	 * 消息处理方法
	 * 
	 * @param chanel
	 *            队列名称
	 * @param msg
	 *            消息json串
	 */
	@Override
	public void onMessage(String chanel, String msg) {
		Message message = new Message();
		message.setChanel(chanel);
		message.setMsg(msg);
		msgHandler.handle(message);
	}

	/**
	 * 订阅初始化方法
	 * 
	 * @param chanel
	 *            队列名称
	 * @param i
	 *            第几个队列
	 */
	@Override
	public void onSubscribe(String chanel, int i) {
		onOrUnSubHandle(subHandler, chanel, i);
	}

	/**
	 * 取消订阅方法
	 * 
	 * @param chanel
	 *            队列名称
	 * @param i
	 *            第几个队列
	 */
	@Override
	public void onUnsubscribe(String chanel, int i) {
		onOrUnSubHandle(unSubHandler, chanel, i);
	}

	/**
	 * 取得按表达式的方式订阅的消息后的处理
	 */
	@Override
	public void onPMessage(String s, String s1, String s2) {

	}

	/**
	 * 取消按表达式的方式订阅的消息后的处理
	 */
	@Override
	public void onPUnsubscribe(String s, int i) {

	}

	/**
	 * 初始化按表达式订阅时候的处理
	 */
	@Override
	public void onPSubscribe(String s, int i) {

	}

	public Handler getMsgHandler() {
		return msgHandler;
	}

	public void setMsgHandler(Handler msgHandler) {
		this.msgHandler = msgHandler;
	}

	public Handler getSubHandler() {
		return subHandler;
	}

	public void setSubHandler(Handler subHandler) {
		this.subHandler = subHandler;
	}

	public Handler getUnSubHandler() {
		return unSubHandler;
	}

	public void setUnSubHandler(Handler unSubHandler) {
		this.unSubHandler = unSubHandler;
	}

	private void onOrUnSubHandle(Handler subHandler,String chanel ,int i){
        if(subHandler == null){
            logger.debug("subHandler:chanel名称:[{}]:i:[{}]",chanel,i);
        }else {
            Message message = new Message();
            message.setChanel(chanel);
            message.setIndex(i);
            subHandler.handle(message);
        }
    }
}