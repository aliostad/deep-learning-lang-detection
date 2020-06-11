
//Chain of Responsiblity模式例子
//将请求在链上传递
//如果是当前节点的请求就结束传递处理请求否则向下传递请求
//每个节点有另一个节点的引用 实现链状结构


package pattern.c.chain_of_responsiblity;

interface Handler{
	void handleRequest(int key);
}

class ConHandler1 implements Handler {
	private Handler handler;
	
	public ConHandler1(Handler handler) {
		this.handler = handler;
	}
	
	public void handleRequest(int key) {
		if (key == 1) {
			System.out.println("handle in 1");
			//handle something
		} else {
			handler.handleRequest(key);
		}
	}
}

class ConHandler2 implements Handler {
	private Handler handler;
	
	public ConHandler2(Handler handler) {
		this.handler = handler;
	}
	
	public void handleRequest(int key) {
		if (key == 2) {
			System.out.println("handle in 2");
			//handle something
		} else {
			handler.handleRequest(key);
		}
	}
}

class ConHandler3 implements Handler {
	private Handler handler;
	
	public ConHandler3(Handler handler) {
		this.handler = handler;
	}
	
	public void handleRequest(int key) {
		if (key == 3) {
			System.out.println("handle in 3");
			//handle something
		} else {
			handler.handleRequest(key);
		}
	}
}

public class ChainOfResponsiblityPattern {
	public static void main(String[] args) {
		Handler handler = new ConHandler2(new ConHandler1(new ConHandler3(null)));
		handler.handleRequest(3);
	}
}
