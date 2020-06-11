package de.consutor.xmlmapper.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import de.consutor.xmlmapper.persistence.entity.Person;

/**
 * Repository class for the entity.
 * 
 * @author Capgemini, Lars Schneider $ID$
 */
// @Transactional(propagation = Propagation.MANDATORY)
@Repository
public interface PersonRepository extends JpaRepository<Person, Long> {

	/**
	 * Standard CRUD functionality is available via the JpaRepository.
	 */

}
