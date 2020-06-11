package com.app.server.service;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
public class ServiceManager {
	private static ServiceManager serviceManager = new ServiceManager();
	private PropertiesConfiguration configuration;
	private ServerListService serverListService;
	private ConfigService configService;
	private UserInfoService userInfoService;
	private LineService lineService;
	private UdidService udidService;
	private VersionService VersionService;

	private ServiceManager() {
	}
	public static ServiceManager getManager() {
		return serviceManager;
	}
	public void initService() {
		try {
			this.loadConfig();
			this.userInfoService = new UserInfoService();
			this.lineService = new LineService();
			this.configService = new ConfigService();
			this.serverListService = new ServerListService();
			this.udidService = new UdidService();
			this.VersionService = new VersionService();

		} catch (ConfigurationException e) {
			e.printStackTrace();
		}

	}

	public void loadConfig() throws ConfigurationException {
		this.configuration = new PropertiesConfiguration("config.properties");
	}

	public ServerListService getServerListService() {
		return this.serverListService;
	}

	public PropertiesConfiguration getConfiguration() {
		return this.configuration;
	}

	// public AccountSkeleton getAccountSkeleton() {
	// return accountSkeleton;
	// }
	public ConfigService getConfigService() {
		return configService;
	}

	public UserInfoService getUserInfoService() {
		return userInfoService;
	}

	public LineService getLineService() {
		return lineService;
	}

	public UdidService getUdidService() {
		return udidService;
	}

	public VersionService getVersionService() {
		return VersionService;
	}
}
