/* Copyright © 2010 www.myctu.cn. All rights reserved. */
package com.sirius.upns.server.node.repository.config;

import com.sirius.upns.server.node.repository.GroupRepository;
import com.sirius.upns.server.node.repository.impl.MemGroupRepository;
import com.sirius.upns.server.node.repository.impl.MongoGroupRepository;
import org.apache.commons.lang3.Validate;
import org.springframework.beans.factory.annotation.Autowire;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @project node-server
 * @date 2013-8-29-下午2:37:48
 * @author pippo
 */
@Configuration
public class GroupRepositoryConfig {

	@Value("${ctu.upns.server.node.repository.group.type}")
	private String type;

	private GroupRepository repository;

	@Bean(autowire = Autowire.BY_TYPE, name = "ctu.upns.groupRepository")
	public GroupRepository instance() {

		if (repository != null) {
			return repository;
		}

		switch (type) {
			case "memory":
				repository = new MemGroupRepository();
			case "mongo":
				repository = new MongoGroupRepository();
		}

		Validate.notNull(repository, "invalid repository type:[%s]", type);
		return repository;
	}
}
