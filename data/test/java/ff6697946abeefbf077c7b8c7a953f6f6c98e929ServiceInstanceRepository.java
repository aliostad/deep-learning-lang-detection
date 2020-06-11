package com.resourcebroker.common.repository;

import com.resourcebroker.common.entitiy.ServiceUserEntity;
import com.resourcebroker.common.exception.ApplicationException;

import java.io.UnsupportedEncodingException;

/**
 * @author: Andrey Kozlov
 */
public interface ServiceInstanceRepository {

    String createService(String serviceName);

    ServiceUserEntity createServiceUser(ServiceUserEntity serviceUser) ;

    void addUserToServiceInstance(ServiceUserEntity serviceUser, String serviceName) ;

    void deleteService(String serviceName);

    void deleteServiceUser(ServiceUserEntity serviceUser);

}
