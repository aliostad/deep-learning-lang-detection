package com.dm.estore.core.springdata.support;

import java.io.Serializable;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.NoRepositoryBean;
import org.springframework.data.repository.history.RevisionRepository;

/**
 * Convenience interface to allow pulling in {@link JpaRepository} and {@link RevisionRepository} functionality in one
 * go.
 * 
 * @author Oliver Gierke
 */
@NoRepositoryBean
public interface EnversRevisionRepository<T, ID extends Serializable, N extends Number & Comparable<N>> extends
		RevisionRepository<T, ID, N>, JpaRepository<T, ID> {

}
