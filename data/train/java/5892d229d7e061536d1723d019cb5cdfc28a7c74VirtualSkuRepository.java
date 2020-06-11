package com.koitoer.springangular.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.stereotype.Repository;

import com.koitoer.springangular.model.VirtualSkuEntity;

@RepositoryRestResource(path = "virtuals", collectionResourceRel = "virtuals",
		itemResourceRel = "virtuals/{id}")
@Repository
public interface VirtualSkuRepository extends JpaRepository<VirtualSkuEntity, String> {

}