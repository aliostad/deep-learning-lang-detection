package partner.chainOfResponsibility.boyAndGirl;

//检查是否有责任心
public class ResponsibilityHandler implements Handler{ 
	private Handler handler;

	public ResponsibilityHandler(Handler handler) {
		this.handler = handler;
	}

	public Handler getHandler() {
		return handler;
	}

	public void setHandler(Handler handler) {
		this.handler = handler;
	}

	public void handleRequest(Boy boy) {
		if(boy.isHasResponsibility()){
			System.out.println("我只有一颗带Responsibility的心");
		}else{
			System.out.println("更没有责任心");
			handler.handleRequest(boy);
		}

	}
}
