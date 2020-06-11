package com.pettypal.repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.pettypal.domain.Credential;

@Repository
public interface CredentialRepository extends CrudRepository<Credential, Long> {

	@Query("Select c from credential c where c.username =:username")
	Credential getCredentialByUsername(@Param("username") String username);
}
