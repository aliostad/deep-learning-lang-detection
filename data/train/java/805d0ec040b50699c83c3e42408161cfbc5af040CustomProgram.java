package net.nilosplace.Data.programs;

import net.nilosplace.Data.handlers.PopulationHandler;

public class CustomProgram extends CommandProgram {

	public CustomProgram(PopulationHandler ph) {
		super(ph);
		
		
		//processCommand("candle load DAT_ASCII_AUDJPY_M1_201401.csv");
		
		processCommand("candle load DAT_ASCII_AUDJPY_M1_2013.csv");
		processCommand("trader load file_2014_mut_gen02");
		processCommand("trader reset");
		
		processCommand("trader process");
		processCommand("trader stats");
		processCommand("trader prune");
		processCommand("trader reset");
		processCommand("trader breed");
		
		processCommand("trader process");
		processCommand("trader stats");
		processCommand("trader prune");
		processCommand("trader reset");
		processCommand("trader breed");
		
		processCommand("trader process");
		processCommand("trader stats");
		processCommand("trader prune");
		processCommand("trader reset");
		processCommand("trader breed");
		
		processCommand("trader process");
		processCommand("trader stats");
		processCommand("trader prune");
		processCommand("trader reset");
		processCommand("trader breed");
		
		processCommand("trader process");
		processCommand("trader stats");
		processCommand("trader prune");
		processCommand("trader reset");
		processCommand("trader breed");
		
		processCommand("trader process");
		processCommand("trader stats");
		processCommand("trader prune");
		processCommand("trader reset");
		processCommand("trader breed");
		
		processCommand("trader process");
		processCommand("trader stats");
		processCommand("trader prune");
		processCommand("trader reset");
		
		processCommand("candle load DAT_ASCII_AUDJPY_M1_201401.csv");
		processCommand("trader process");
		processCommand("trader stats");
		
		processCommand("trader save file_2014_mut_gen03");
		
		processCommand("quit");
	}

}
