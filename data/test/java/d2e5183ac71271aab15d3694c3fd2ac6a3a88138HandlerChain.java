package com.vip.metricprobe.extend.chain;

import com.vip.metricprobe.extend.domain.Data;
import com.vip.metricprobe.extend.domain.DataFeature;

import java.util.List;



/**
 * 处理器链
 * Created by dongqingswt on 14-11-8.
 */
public class HandlerChain {



	private Handler headHandler ;

	private Handler tailHandler;




	class HeadHandler extends BaseHandler{


		public HeadHandler(Handler nextHandler) {
			super(nextHandler);
		}
	}

	class TailHandler extends BaseHandler{

		public TailHandler(Handler nextHandler) {
			super(nextHandler);
		}
	}

	public HandlerChain(){
		//尾的next是null .
		this.tailHandler = new TailHandler(null);
		//头的next是尾 ；
		this.headHandler = new HeadHandler(this.tailHandler);

	}

	public HandlerChain(List<Handler> handlerList){
		//尾的next是null .
		this.tailHandler = new TailHandler(null);
		//头的next是尾 ；
		this.headHandler = new HeadHandler(this.tailHandler);

		for(Handler handler: handlerList){
			this.addHandler(handler);
		}
	}

	public void addHandler(Handler handler){
		assert(handler != null) ;
		Handler prevHandler = this.headHandler ,currentHandler =  this.headHandler;
		while(currentHandler != this.tailHandler){
			prevHandler = currentHandler;
			currentHandler = currentHandler.next();
		}
		prevHandler.setNext(handler);
		handler.setNext(this.tailHandler);

	}



    public void handle(Data data){
        this.headHandler.handle(data);
    }


    /**
     * 拷贝一个处理器链。 这里做的是一个deep copy .
     * @return
     */
	public HandlerChain copySelf(){
		HandlerChain handlerChain = new HandlerChain() ;
		Handler currentHandler  = this.headHandler;
		Handler h =  null ;
		while((h = currentHandler.next())!= null && !(currentHandler.next() instanceof  TailHandler)){   //这里因为是拷贝出来的，所以需要用是否是TailHandler来判断。
			handlerChain.addHandler(h.copySelf());
			currentHandler = currentHandler.next();
		}


		return handlerChain;
	}

	public  void setDataFeature(DataFeature dataFeature){

		//设置处理器链中的每一个handler的处理特性。 
		Handler currentHandler = this.headHandler; 
		while((currentHandler = currentHandler.next()) != this.tailHandler){
			currentHandler.setDataFeature(dataFeature); 
		}

	}

	public void doOtherInitialWork() {
		Handler currentHandler = this.headHandler; 
		while((currentHandler = currentHandler.next()) != this.tailHandler){
			currentHandler.doOtherInitialWork();
		}

	}







}
