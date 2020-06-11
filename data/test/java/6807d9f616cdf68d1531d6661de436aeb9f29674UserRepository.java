package com.ostwebdev.fantasystrategy.repository;

import org.springframework.data.neo4j.repository.GraphRepository;
import org.springframework.data.neo4j.repository.RelationshipOperationsRepository;
import org.springframework.stereotype.Repository;

import com.ostwebdev.fantasystrategy.domain.Square;
import com.ostwebdev.fantasystrategy.domain.User;
import java.lang.String;
import java.util.List;

@Repository
public interface UserRepository extends GraphRepository<User> {
	User findByUsername(String username);

}