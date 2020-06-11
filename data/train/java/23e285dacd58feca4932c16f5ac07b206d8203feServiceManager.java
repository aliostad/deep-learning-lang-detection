package com.formation.jee.service;

import com.formation.jee.service.impl.ItemServiceImpl;
import com.formation.jee.service.impl.PlayerServiceImpl;

public enum ServiceManager {
	
	INSTANCE;

	private PlayerService playerService;
	private ItemService itemService;

	public PlayerService getPlayerService() {
		if(playerService == null)
			playerService = new PlayerServiceImpl();
		return playerService;
	}

	public ItemService getItemService() {
		if(itemService == null)
			itemService = new ItemServiceImpl();
		return itemService;
	}
}
