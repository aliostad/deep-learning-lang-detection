package com.imarkofu.designpatterns.q;

/**
 * 责任链模式
 * 		有多个对象，每个对象持有对下一个对象的引用，这样就会形成一条链，请求在这条链上传递，直到某一对象决定处理该请求。
 * 		但是发出这并不清楚到底最终那个对象会处理该请求，所以，责任链模式可以实现，该隐瞒客户端的情况下，对系统进行动态的调整。
 * 
 * 总结
 * 		此处强调一点就是，链接上的请求可以是一条链，可以是一个树，还可以是一个环，模式本身不约束这个，需要我们自己去实现，
 * 		同时，在一个时刻，命令只允许有一个对象传给另一个对象，而不允许传给多个对象。
 * 
 * @author Administrator
 *
 */
public class ChainOfResponsibilityPatterns {

	public static void main(String[] args) {
		MyHandler handler1 = new MyHandler("handler1");
		MyHandler handler2 = new MyHandler("handler2");
		MyHandler handler3 = new MyHandler("handler3");
		
		handler1.setHandler(handler2);
		handler2.setHandler(handler3);
		handler1.operator();
	}
}
interface Handler {
	public void operator();
}
abstract class AbstractHandler implements Handler {
	private Handler handler;
	public Handler getHandler() {
		return handler;
	}
	public void setHandler(Handler handler) {
		this.handler = handler;
	}
}
class MyHandler extends AbstractHandler implements Handler {
	private String name;
	public MyHandler(String name) {
		this.name = name;
	}
	@Override
	public void operator() {
		System.out.println(name+" operator()");
		if (getHandler() != null) {
			getHandler().operator();
		}
	}
}