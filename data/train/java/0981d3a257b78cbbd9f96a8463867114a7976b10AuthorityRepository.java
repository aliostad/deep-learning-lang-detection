package com.mbank.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.mbank.model.Authorities;

@Repository("authorityRepository")
public interface AuthorityRepository extends JpaRepository<Authorities, String>{

	@Modifying
	@Query("Delete Authorities where clientId=?1")
	public void delete(Long clientId);

}
