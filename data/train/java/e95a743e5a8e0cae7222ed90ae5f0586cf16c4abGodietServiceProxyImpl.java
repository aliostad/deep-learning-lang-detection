package com.sysfera.godiet.common.services;

import com.sysfera.godiet.common.exceptions.generics.StartException;
import com.sysfera.godiet.common.services.ConfigurationService;
import com.sysfera.godiet.common.services.GoDietService;
import com.sysfera.godiet.common.services.InfrastructureService;
import com.sysfera.godiet.common.services.PlatformService;
import com.sysfera.godiet.common.services.UserService;
import com.sysfera.godiet.common.services.XMLLoaderService;


public class GodietServiceProxyImpl implements GoDietService {

	
	private InfrastructureService infrastructureService;
	
	private PlatformService platformService;
	
	private UserService userService;
	
	private XMLLoaderService xMLLoaderService;
	
	private ConfigurationService configurationService;

	@Override
	public void start() throws StartException {
		// TODO Auto-generated method stub

	}

	@Override
	public PlatformService getPlatformService() {
		return platformService;
	}

	@Override
	public XMLLoaderService getXmlHelpService() {
		return xMLLoaderService;
	}

	@Override
	public InfrastructureService getInfrastructureService() {
		return infrastructureService;
	}

	@Override
	public UserService getUserService() {
		return userService;
	}

	@Override
	public ConfigurationService getConfigurationService() {
		return configurationService;
	}

	public XMLLoaderService getxMLLoaderService() {
		return xMLLoaderService;
	}

	public void setxMLLoaderService(XMLLoaderService xMLLoaderService) {
		this.xMLLoaderService = xMLLoaderService;
	}

	public void setInfrastructureService(InfrastructureService infrastructureService) {
		this.infrastructureService = infrastructureService;
	}

	public void setPlatformService(PlatformService platformService) {
		this.platformService = platformService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public void setConfigurationService(ConfigurationService configurationService) {
		this.configurationService = configurationService;
	}

}
