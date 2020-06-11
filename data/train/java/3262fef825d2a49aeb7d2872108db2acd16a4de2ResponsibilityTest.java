package com.phynero.test;

public class ResponsibilityTest {
	public interface Handler{
		public void operator();
	}
	
	public abstract class AbstractHandler{
		private Handler handler;
		public Handler getHandler(){
			return handler;
		}
		public void setHandler(Handler handler){
			this.handler = handler;
		}
	}
	
	public class MyHandler extends AbstractHandler implements Handler{
		private String name;
		public MyHandler(String name){
			this.name = name;
		}
		
		@Override
		public void operator() {
			System.out.println(name + "deal!");
			if(getHandler()!=null){
				getHandler().operator();
			}
		}
	}
	
	public static void main(String[] str){
		System.out.println("ÔðÈÎÁ´Ä£Ê½");
		ResponsibilityTest test = new ResponsibilityTest();
		MyHandler h1 = test.new MyHandler("h1");
		MyHandler h2 = test.new MyHandler("h2");
		MyHandler h3 = test.new MyHandler("h3");
		
		h1.setHandler(h2);
		h2.setHandler(h3);
		h1.operator();
	}
}
