package ru.twelveyes.repository;

import org.springframework.data.neo4j.repository.GraphRepository;
import org.springframework.data.neo4j.repository.RelationshipGraphRepository;
import org.springframework.data.neo4j.repository.SpatialRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import ru.twelveyes.domain.Contact;

/**
 * User: Krainov
 * Date: 28.02.14
 * Time: 12:53
 */
public interface ContactRepository extends GraphRepository<Contact>, SpatialRepository<Contact> {
}
