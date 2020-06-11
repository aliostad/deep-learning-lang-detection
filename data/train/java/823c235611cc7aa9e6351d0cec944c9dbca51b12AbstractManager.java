package com.sportnetwork.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sportnetwork.common.service.IDeviceService;
import com.sportnetwork.common.service.IEventService;
import com.sportnetwork.common.service.IVenueService;

@Service
public class AbstractManager {

	@Autowired
	protected IVenueService venueService;
	
	@Autowired
	protected IDeviceService deviceService;
	
	@Autowired
	protected IEventService eventService;
	
}
