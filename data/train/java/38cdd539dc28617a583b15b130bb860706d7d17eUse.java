package BehavioralPatterns.ChainOfResponsibility;

public class Use {

	public Use()
	{
		System.out.println("[ChainOfReponsibility]");
		
		//Ñîçäàåì âñþ öåïî÷êó îáðàáîò÷èêîâ
		//Ãëàâíûé îáðàáîò÷èê
		Handler thirdHandler = new ThirdConcreteHandler();
		//Ñðåäíèé îáðàáîò÷èê
		Handler secondHandler = new SecondConcreteHandler(thirdHandler);
		//Ìëàäøèé îáðàáîò÷èê
		Handler firstHandler = new FirstConcreteHandler(secondHandler);
		
		//Íà÷èíàåì âûñûëàòü çàïðîñû ñàìîìó ìëàäøåìó îáðàáîò÷èêó
		firstHandler.handleIt(1);
		firstHandler.handleIt(2);
		firstHandler.handleIt(3);
		
		System.out.println();
	}
}
