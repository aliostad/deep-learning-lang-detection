package chainOfResponsabilities;

public class Main {

	public static void main(String[] args) {
		HandlerA handlerA=new HandlerA();
		HandlerB handlerB=new HandlerB();
		HandlerC handlerC=new HandlerC();
		handlerA.setHandler(handlerB);
		handlerB.setHandler(handlerC);
		
		tryToHandle(handlerA, "A");
		tryToHandle(handlerB, "B");
		tryToHandle(handlerC, "C");
		tryToHandle(handlerA, "Ciao");
	}
	
	public static void tryToHandle(Handler handler,String message){
		System.out.println("Trying to handle "+handler);
		if(!handler.handle(message)){
			System.out.println(message+" cannot be handled");
		}
	}
}
