package partner.chainOfResponsibility.boyAndGirl;

//检查是否有房
public class HouseHandler implements Handler{
	private Handler handler;

	public HouseHandler(Handler handler) {

		this.handler = handler;
	}

	public Handler getHandler() {
		return handler;
	}

	public void setHandler(Handler handler) {
		this.handler = handler;
	}

	public void handleRequest(Boy boy) {
		if(boy.isHasHouse()){
			System.out.println("没想到吧，我还有房子");
		}else{
			System.out.println("我也没有房");
			handler.handleRequest(boy);
		}

	}

}
