package com.mylab.learn.testpoc.service;

import com.mylab.learn.testpoc.service.dto.SearchServiceRequest;
import com.mylab.learn.testpoc.service.dto.SearchServiceResponse;
import com.mylab.learn.testpoc.service.dto.SendServiceRequest;
import com.mylab.learn.testpoc.service.dto.SendServiceResponse;

/**
 * 
 * @author cmartin
 *
 */
public interface MessageService {
    /**
     * 
     * @param sendServiceRequest
     * @return
     * @throws MessageServiceException
     */
    SendServiceResponse send(SendServiceRequest sendServiceRequest)
            throws MessageServiceException;

    /**
     * 
     * @param searchServiceRequest
     * @return
     * @throws MessageServiceException
     */
    SearchServiceResponse search(SearchServiceRequest searchServiceRequest)
            throws MessageServiceException;
}
