package com.imooc.design.orc;

import java.util.Random;

import com.imooc.design.orc.handler.PriceHandler;

public class Customer {
	
	private PriceHandler handler;

	public void setHandler(PriceHandler handler) {
		this.handler = handler;
	}
	
	//客户请求折扣
	public  void requestAccount(float disaccount){
		handler.caluPriceHandler(disaccount);
	}
	
	public static void main(String[] args) {
		Customer cus=new Customer();
		cus.setHandler(PriceHandler.createPriceHandler());
        Random ran=new Random();
        for(int i=0;i<50;i++){
        	cus.requestAccount(ran.nextFloat());
        }
	}

}
