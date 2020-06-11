package com.entelgy.sysvoting.repository.jpa;

import org.springframework.stereotype.Repository;

import com.entelgy.sysvoting.entity.Option;
import com.entelgy.sysvoting.repository.OptionRepository;
import com.entelgy.sysvoting.repository.jpa.generic.GenericRepositoryJpa;

/**
 * The OptionRepositoryJpa class provides the persistence operations of entity option
 * 
 */
@Repository("optionRepositoryJpa")
public class OptionRepositoryJpa extends GenericRepositoryJpa<Option, Long> implements OptionRepository {

}
