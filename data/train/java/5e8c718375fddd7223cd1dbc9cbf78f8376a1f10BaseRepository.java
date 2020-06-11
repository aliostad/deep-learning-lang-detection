package com.ec.base.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.NoRepositoryBean;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.io.Serializable;

/**
 * User: chaocui200783
 * Date: 14-10-25
 * Time: 下午2:14
 */

@NoRepositoryBean
public interface BaseRepository<T, ID extends Serializable> extends CrudRepository<T,ID>,PagingAndSortingRepository<T,ID>,JpaRepository<T,ID> {

}
