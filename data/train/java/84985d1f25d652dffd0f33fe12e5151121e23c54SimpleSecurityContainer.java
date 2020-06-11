package security.container.impl;

import security.container.config.ConfigurationManage;
import security.container.encrypt.impl.SecurityFactory;
import security.container.manage.SecurityDataManage;

public class SimpleSecurityContainer {
	private SecurityDataManage securityDataManage;
	private SecurityFactory securityFactory;
	private ConfigurationManage configurationManage;
	private String targetSrc;
	private String workSpace;
	private String id;
	
	public SimpleSecurityContainer(String targetSrc, String workSpace, String id) {
		this.targetSrc = targetSrc;
		this.workSpace = workSpace;
		this.id = id;
		initialize();
	}
	
	public void initialize() {
		this.securityDataManage = new SecurityDataManage(targetSrc);
		this.securityFactory = SecurityFactory.getInstance(workSpace, id);
		this.configurationManage = new ConfigurationManage();
	}
	
	/**
	 * @return the targetSrc
	 */
	public String getTargetSrc() {
		return targetSrc;
	}
	/**
	 * @param targetSrc the targetSrc to set
	 */
	public void setTargetSrc(String targetSrc) {
		this.targetSrc = targetSrc;
	}
	/**
	 * @return the workSpace
	 */
	public String getWorkSpace() {
		return workSpace;
	}
	/**
	 * @param workSpace the workSpace to set
	 */
	public void setWorkSpace(String workSpace) {
		this.workSpace = workSpace;
	}

	/**
	 * @return the securityFactory
	 */
	public SecurityFactory getSecurityFactory() {
		return securityFactory;
	}

	/**
	 * @param securityFactory the securityFactory to set
	 */
	public void setSecurityFactory(SecurityFactory securityFactory) {
		this.securityFactory = securityFactory;
	}

	/**
	 * @return the securityDataManage
	 */
	public SecurityDataManage getSecurityDataManage() {
		return securityDataManage;
	}

	/**
	 * @param securityDataManage the securityDataManage to set
	 */
	public void setSecurityDataManage(SecurityDataManage securityDataManage) {
		this.securityDataManage = securityDataManage;
	}

	/**
	 * @return the configurationManage
	 */
	public ConfigurationManage getConfigurationManage() {
		return configurationManage;
	}

	/**
	 * @param configurationManage the configurationManage to set
	 */
	public void setConfigurationManage(ConfigurationManage configurationManage) {
		this.configurationManage = configurationManage;
	}

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}
}
