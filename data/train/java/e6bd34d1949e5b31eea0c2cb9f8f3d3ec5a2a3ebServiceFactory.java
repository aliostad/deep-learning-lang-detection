package com.fantasy.football.auctionpro;

import com.fantasy.football.auctionpro.service.ConfigurationService;
import com.fantasy.football.auctionpro.service.FileService;
import com.fantasy.football.auctionpro.service.TeamService;
import com.fantasy.football.auctionpro.service.VbdService;
import com.fantasy.football.auctionpro.service.impl.ConfigurationServiceImpl;
import com.fantasy.football.auctionpro.service.impl.FileServiceImpl;
import com.fantasy.football.auctionpro.service.impl.TeamServiceImpl;
import com.fantasy.football.auctionpro.service.impl.VbdServiceImpl;

/**
 * Service Factory
 * 
 * @author Derek
 *
 */
public class ServiceFactory {

	/** Configuration Service */
	private static ConfigurationService configurationService;
	
	/** File Service */
	private static FileService fileService;
	
	/** Player Data Service */
	private static VbdService vbdService;
	
	/** Team Service*/
	private static TeamService teamService;

	/**
	 * Get Configuration Service
	 * 
	 * @return ConfigurationService
	 */
	public static ConfigurationService getConfigurationService() {
		if( configurationService == null ) {
			configurationService = new ConfigurationServiceImpl();
		}
		
		return configurationService;
	}

	/**
	 * Get File Service
	 * 
	 * @return FileService
	 */
	public static FileService getFileService() {
		if( fileService == null ) {
			fileService = new FileServiceImpl();
		}
		
		return fileService;
	}

	/**
	 * Get Vbd Service
	 * 
	 * @return VbdService
	 */
	public static VbdService getVbdService() {
		if( vbdService == null ) {
			vbdService = new VbdServiceImpl();
		}
		
		return vbdService;
	}

	/**
	 * Get The Team Service
	 * 
	 * @return TeamService
	 */
	public static TeamService getTeamService() {
		if( teamService == null ) {
			teamService = new TeamServiceImpl();
		}
		
		return teamService;
	}
	
}
