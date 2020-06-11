package com.ewaves.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.ewaves.entities.LoginDetails;

@Repository
public interface LoginRepository extends CrudRepository<LoginDetails, Long>, JpaRepository<LoginDetails, Long> {

	LoginDetails findByUsernameAndPassword(String username, String password);

	LoginDetails findByUsername(String username);

}
