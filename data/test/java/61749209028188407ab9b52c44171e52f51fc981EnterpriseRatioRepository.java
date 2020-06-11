package com.springapp.mvc.repository.implementation;

import com.springapp.mvc.entity.EnterpriseRatio;
import com.springapp.mvc.repository.implementation.EntityRepository;
import com.springapp.mvc.repository.IEnterpriseRatioRepository;
import org.springframework.stereotype.Repository;

@Repository
public class EnterpriseRatioRepository extends EntityRepository<EnterpriseRatio> implements IEnterpriseRatioRepository {

    protected EnterpriseRatioRepository() {
        super(EnterpriseRatio.class);
    }
}
