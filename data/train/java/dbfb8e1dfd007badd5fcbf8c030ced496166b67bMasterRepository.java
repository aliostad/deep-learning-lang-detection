package com.practice.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;

import com.practice.model.Master;

/**
 * Repository interface for {@link Master} instances. Provides basic CRUD operations due to the extension of
 * {@link JpaRepository}. Includes custom implemented functionality by extending {@link MasterRepositoryCustom}.
 * 
 * @author Dan Idoux
 */
public interface MasterRepository extends CrudRepository<Master, Integer> {

}
