package com.socialcooking.repository;

import com.socialcooking.domain.Ingredient;
import com.socialcooking.repository.api.IngredientRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository
@Transactional
public class IngredientRepositoryImpl extends GenericRepositoryImpl<Ingredient> implements IngredientRepository {

    private Logger log = LoggerFactory.getLogger(IngredientRepositoryImpl.class);

}
