package com.vub.repository;

import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.vub.model.Institution;

/**
 * 
 * @author Sam
 *
 */
@Repository
public interface InstitutionRepository extends JpaRepository<Institution, Integer> {
	@Query(value="SELECT i FROM Institution i WHERE i.name = :institution")
	public Institution getInstitution(@Param("institution") String institution);
}