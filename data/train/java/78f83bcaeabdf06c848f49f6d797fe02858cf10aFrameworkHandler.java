package com.school.snake;

import android.app.Activity;

public class FrameworkHandler extends Thread
{	
	UI_Mainframe	threadUI;
	InputHandler	handlerInput;
	GameHandler		handlerGame;
	Thread			threadInput,
					threadGame;
	Activity		activityUI;
	
	public FrameworkHandler(UI_Mainframe threadUI, Activity activityUI)
	{
		this.threadUI			=	threadUI;
		this.activityUI			=	activityUI;
		
		handlerInput			=	new InputHandler(this);
		handlerInput.start();
		handlerGame				=	new GameHandler(this);
		handlerGame.start();
				
		/*threadInput				=	new	Thread(handlerInput);
		handlerInput.start();
		threadGame				=	new	Thread(handlerGame);
		handlerGame.start();*/
	}
	
	public void run()	{	}
	
	public void newGame()
	{
		handlerGame.startGame();
	}
		
	public void exitApp()
	{
		handlerGame.terminate();
		handlerInput.terminate();
		interrupt();		
	}
}