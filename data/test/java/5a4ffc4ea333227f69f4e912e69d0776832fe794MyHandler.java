package designMode.ChainOfResponsibility;

public class MyHandler extends AbstractHandler implements Handler{
	
	private String name;
	
	public MyHandler(String name){
		this.name=name;
	}
	

	@Override
	public void operator() {
		// TODO Auto-generated method stub
		System.out.println(name+":deal!");
		Handler handler=getHandler();
		if(handler!=null){
			handler.operator();
		}
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MyHandler handler_A=new MyHandler("A");
		MyHandler handler_B=new MyHandler("B");
		MyHandler handler_C=new MyHandler("C");
		handler_A.setHandler(handler_B);
		handler_B.setHandler(handler_C);
		handler_A.operator();
	}

}
