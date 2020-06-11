package org.rtk.getaroom.repository;

import org.rtk.getaroom.entity.Building;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.stereotype.Repository;


@RepositoryRestResource
public interface BuildingRepository extends
        PagingAndSortingRepository<Building, Long> {
}
//
//@Repository
//public interface BuildingRepository extends CrudRepository<Building, Long> {
//    public Building findBuildingByCode(String code);
//}