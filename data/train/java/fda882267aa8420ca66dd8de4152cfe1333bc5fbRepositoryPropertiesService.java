package com.csc.core.framework.repository.service;


import java.util.List;

import com.csc.core.framework.repository.exceptions.RepositoryPropertiesNotFoundException;
import com.csc.core.framework.repository.properties.JackRabbitRepositoryProperties;

/**
 * Service layer class for Repository Properties
 *
 * @author goutham_PN
 */
public interface RepositoryPropertiesService {

    JackRabbitRepositoryProperties getJackRabbitRepository(String repositoryId) throws RepositoryPropertiesNotFoundException;

	List<JackRabbitRepositoryProperties> getRepositoryList()
			throws RepositoryPropertiesNotFoundException;

    List<String> getTenantsList();

    void setJackRabbitRepository(JackRabbitRepositoryProperties jackRabbitRepositoryProperties);
}
