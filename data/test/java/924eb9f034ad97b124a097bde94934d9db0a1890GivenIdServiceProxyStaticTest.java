package org.soad.webmvc.admin.controller;

import junit.framework.Assert;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.soad.orm.repo.scat.ServiceRepository;
import org.soad.orm.scat.Service;
import org.soad.orm.scat.ServiceProxy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;


@ContextConfiguration(value = "classpath:org/soad/webmvc/repository/datasource-context.xml")
@RunWith(SpringJUnit4ClassRunner.class)
@TransactionConfiguration(defaultRollback = false)
@Transactional
public class GivenIdServiceProxyStaticTest {
	private Logger logger = LoggerFactory
			.getLogger(GivenIdServiceProxyStaticTest.class);

	@Autowired
	private ServiceRepository serviceRepository;
	

	@Test
	public void deleteServiceProxy(){		
		Service fromService = new Service();
		fromService.setDescription("A simple service");
		fromService.setName("Dummy service");
		serviceRepository.save(fromService);
		
		Assert.assertNotNull(fromService.getId());
	
		Service toService = new Service();
		toService.setName("Target service");
		toService.setDescription("blah blah");
		
		serviceRepository.save(toService);
		Assert.assertNotNull(toService.getId());
	
		fromService.getServiceProxies().add(new ServiceProxy(fromService, toService));
		serviceRepository.save(fromService);
		
		fromService = serviceRepository.findOne(fromService.getId());
		toService = serviceRepository.findOne(toService.getId());
		
		ServiceProxy serviceProxy = new ServiceProxy(fromService, toService);
		Assert.assertTrue(fromService.getServiceProxies().contains(serviceProxy));
		
		fromService.getServiceProxies().remove(serviceProxy);
		serviceRepository.save(fromService);
		
		Service service = serviceRepository.findOne(fromService.getId());
		Assert.assertFalse(service.getServiceProxies().contains(serviceProxy));
		
		logger.info("Reloaded service and confirmed deleted serviceProxy item from fromService.id {} to toService.id {}", 
				fromService.getId(), toService.getId());
		
	}
	
	
}
