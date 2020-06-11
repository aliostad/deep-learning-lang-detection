package com.hmig.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hmig.domain.bo.ServiceTeam;
import com.hmig.service.ServiceTeamService;
import com.hmig.service.dao.ServiceTeamDao;

@Service
public class ServiceTeamServiceImpl implements ServiceTeamService {
	@Autowired
	ServiceTeamDao serviceTeamDao;
	
	@Override
	public List<ServiceTeam> findServiceTeam(String policyIds) {	
		List<ServiceTeam> results = serviceTeamDao.find(policyIds);
		return results;
	}

	public void ServiceTeamDao(ServiceTeamDao serviceTeamDao) {
		this.serviceTeamDao = serviceTeamDao;
	}

} 
