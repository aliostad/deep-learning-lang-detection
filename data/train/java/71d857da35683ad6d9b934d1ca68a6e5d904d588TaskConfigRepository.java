package com.hengyi.japp.personalevaluation.domain.repository;

import org.springframework.data.neo4j.repository.GraphRepository;
import org.springframework.data.neo4j.repository.NamedIndexRepository;
import org.springframework.data.neo4j.repository.RelationshipOperationsRepository;

import com.hengyi.japp.personalevaluation.domain.node.TaskConfig;

public interface TaskConfigRepository extends GraphRepository<TaskConfig>,
		NamedIndexRepository<TaskConfig>,
		RelationshipOperationsRepository<TaskConfig> {
}
