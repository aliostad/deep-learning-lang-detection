package com.pixelgriffin.empires;

import com.pixelgriffin.empires.handler.BoardHandler;
import com.pixelgriffin.empires.handler.JoinableHandler;
import com.pixelgriffin.empires.handler.PlayerHandler;

/**
 * 
 * @author Nathan
 *
 */
public class EmpiresAPI {
	
	public JoinableHandler getJoinableHandler() {
		return Empires.m_joinableHandler;
	}
	
	public BoardHandler getBoardHandler() {
		return Empires.m_boardHandler;
	}
	
	public PlayerHandler getPlayerHandler() {
		return Empires.m_playerHandler;
	}
}
