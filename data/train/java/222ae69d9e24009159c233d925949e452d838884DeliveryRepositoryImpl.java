package com.socialcooking.repository;

import com.socialcooking.domain.Delivery;
import com.socialcooking.repository.api.DeliveryRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class DeliveryRepositoryImpl extends GenericRepositoryImpl<Delivery> implements DeliveryRepository {

    private Logger log = LoggerFactory.getLogger(DeliveryRepositoryImpl.class);


}
