/* Copyright © 2010 www.myctu.cn. All rights reserved. */
package com.sirius.upns.server.node.repository.config;

import com.sirius.upns.server.node.repository.MessageRepository;
import com.sirius.upns.server.node.repository.impl.MemMessageRepository;
import com.sirius.upns.server.node.repository.impl.MongoMessageRepository;
import org.apache.commons.lang3.Validate;
import org.springframework.beans.factory.annotation.Autowire;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @project node-server
 * @date 2013-9-8-下午11:02:30
 * @author pippo
 */
@Configuration
public class MessageRepositoryConfig {

	@Value("${ctu.upns.server.node.repository.message.type}")
	private String type;

	private MessageRepository repository;

	@Bean(autowire = Autowire.BY_TYPE, name = "ctu.upns.messageRepository")
	public MessageRepository instance() {

		if (repository != null) {
			return repository;
		}

		switch (type) {
			case "memory":
				repository = new MemMessageRepository();
			case "mongo":
				repository = new MongoMessageRepository();
		}

		Validate.notNull(repository, "invalid repository type:[%s]", type);
		return repository;
	}

}
