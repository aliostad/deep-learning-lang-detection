                                                       package com.example.try_gameengine.framework;

import java.util.ArrayList;
import java.util.List;

public class ProcessBlockManager {
	private List<ProcessBlock> preProcessBlocksList = new ArrayList<ProcessBlock>();
	
	private static class ProcessBlockManagerHolder {
		public static ProcessBlockManager ProcessBlockManager = new ProcessBlockManager();
	}

	public static ProcessBlockManager getInstance() {
		return ProcessBlockManagerHolder.ProcessBlockManager;
	}
	
	public void setPreProcessBlock(ProcessBlock processBlock, int sceneIndex){
		
	}
	
	public void setPreProcessBlock(ProcessBlock processBlock, GameModel gameModel){
//		gameModel.set
	}
}
