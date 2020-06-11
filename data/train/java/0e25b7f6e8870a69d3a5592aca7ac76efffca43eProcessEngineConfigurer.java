package org.tynamo.activiti.services;

import org.activiti.engine.ProcessEngineConfiguration;

/**
 * Used to configure a {@link org.activiti.engine.ProcessEngineConfiguration}, which is used to
 * create an {@linkplain org.activiti.engine.ProcessEngine}.
 */
public interface ProcessEngineConfigurer
{
	/**
	 * Configures a ProcessEngineConfiguration.
	 *
	 * @param processEngineConfiguration the ProcessEngineConfiguration to configure
	 */
	void configure(ProcessEngineConfiguration processEngineConfiguration);

}
