package partner.chainOfResponsibility.boyAndGirl;

//检查是否有车
public class CarHandler  implements Handler{
	private Handler handler;
	
	public CarHandler(Handler handler) {
		this.handler = handler;
	}

	public Handler getHandler() {
		return handler;
	}

	public void setHandler(Handler handler) {
		this.handler = handler;
	}

	public void handleRequest(Boy boy) {
		if(boy.isHasCar()){
			System.out.println("呵呵，我有辆车");
		}else{
			System.out.println("我没有车");
			handler.handleRequest(boy);
		}

	}

}
