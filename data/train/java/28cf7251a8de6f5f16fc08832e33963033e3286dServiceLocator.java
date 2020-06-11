package durscht.core.config;

import durscht.contracts.data.IDataHandler;
import durscht.contracts.logic.IBarHandler;
import durscht.contracts.logic.IBeerHandler;
import durscht.contracts.logic.ILogicFacade;
import durscht.contracts.logic.IPostHandler;
import durscht.core.BarHandler;
import durscht.core.BeerHandler;
import durscht.core.LogicFacade;
import durscht.core.LoginHandler;
import durscht.core.PostHandler;
import durscht.data.handler.DataHandler;

public class ServiceLocator {

	private static ILogicFacade logicFacade;

	private static IPostHandler postHandler;
	private static IBeerHandler beerHandler;
	private static IBarHandler barHandler;

	private static LoginHandler loginHandler;
	private static IDataHandler dataHandler;

	public static ILogicFacade getLogicFacade() {
		if (logicFacade == null)
			logicFacade = new LogicFacade();

		return logicFacade;
	}

	public static IPostHandler getPostHandler() {

		if (postHandler == null)
			postHandler = new PostHandler();

		return postHandler;
	}

	public static IBeerHandler getBeerHandler() {
		if (beerHandler == null)
			beerHandler = new BeerHandler();

		return beerHandler;
	}

	public static void setBeerHandler(IBeerHandler beerHandler) {
		ServiceLocator.beerHandler = beerHandler;
	}

	public static IBarHandler getBarHandler() {
		if (barHandler == null)
			barHandler = new BarHandler();

		return barHandler;
	}

	public static IDataHandler getDataHandler() {

		if (dataHandler == null) {
			try {
				dataHandler = new DataHandler();
			}
			catch (IllegalStateException e) {
				dataHandler = new DataHandler();
			}
		}

		return dataHandler;
	}

	public static LoginHandler getLoginHandler() {

		if (loginHandler == null)
			loginHandler = new LoginHandler();

		return loginHandler;
	}
}
