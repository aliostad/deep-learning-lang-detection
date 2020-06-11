package com.socialcooking.repository;

import com.socialcooking.domain.Provider;
import com.socialcooking.repository.api.ProviderRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class ProviderRepositoryImpl extends GenericRepositoryImpl<Provider> implements ProviderRepository {

    private Logger log = LoggerFactory.getLogger(IngredientRepositoryImpl.class);


}
