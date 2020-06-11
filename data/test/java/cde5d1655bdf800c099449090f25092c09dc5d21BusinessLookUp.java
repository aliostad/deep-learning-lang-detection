/**
 * 
 */
package com.jfootball.business;

import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author Alessandro Danesi
 * 
 *         12/set/201422:59:09
 */
public class BusinessLookUp 
{
	
	@Autowired
	private BusinessService careerService;

	@Autowired
	private BusinessService continentService;

	@Autowired
	private BusinessService divisionService;
	
	@Autowired
	private BusinessService nationService;
	
	@Autowired
	private BusinessService playerService;
	
	@Autowired
	private BusinessService staffService;	
	
	@Autowired
	private BusinessService positionService;

	@Autowired
	private BusinessService seasonService;
	
	@Autowired
	private BusinessService teamService;
	
	@Autowired
	private BusinessService userService;
	
	

	public BusinessService getBusinessService(String serviceType) 
	{
		if (serviceType.equalsIgnoreCase("CAREER")) 
		{
			return careerService;
		} 
		else if (serviceType.equalsIgnoreCase("CONTINENT")) 
		{
			return continentService;
		} 
		else if (serviceType.equalsIgnoreCase("DIVISION")) 
		{
			return divisionService;
		} 
		else if (serviceType.equalsIgnoreCase("NATION")) 
		{
			return nationService;
		} 
		else if (serviceType.equalsIgnoreCase("PLAYER")) 
		{
			return playerService;
		} 
		else if (serviceType.equalsIgnoreCase("STAFF")) 
		{
			return staffService;
		} 		
		else if (serviceType.equalsIgnoreCase("POSITION")) 
		{
			return positionService;
		} 		
		else if (serviceType.equalsIgnoreCase("SEASON")) 
		{
			return seasonService;
		} 
		else if (serviceType.equalsIgnoreCase("TEAM")) 
		{
			return teamService;
		} 
		else if (serviceType.equalsIgnoreCase("USER")) 
		{
			return userService;
		} 	
		else 
		{
			throw new RuntimeException("Servizio non trovato");
		}
	}

	
	/******************************************************************************************************************************
	 * 
	 * 											S   E   T   T   E   R   S
	 * 
	 ******************************************************************************************************************************/


	public void setCareerService(BusinessService careerService) {
		this.careerService = careerService;
	}



	public void setContinentService(BusinessService continentService) {
		this.continentService = continentService;
	}



	public void setDivisionService(BusinessService divisionService) {
		this.divisionService = divisionService;
	}



	public void setNationService(BusinessService nationService) {
		this.nationService = nationService;
	}



	public void setPlayerService(BusinessService playerService) {
		this.playerService = playerService;
	}



	public void setPositionService(BusinessService positionService) {
		this.positionService = positionService;
	}



	public void setSeasonService(BusinessService seasonService) {
		this.seasonService = seasonService;
	}



	public void setTeamService(BusinessService teamService) {
		this.teamService = teamService;
	}
	
	
	public void setStaffService(BusinessService staffService) {
		this.staffService = staffService;
	}	



	public void setUserService(BusinessService userService) {
		this.userService = userService;
	}
	
	
	
}
