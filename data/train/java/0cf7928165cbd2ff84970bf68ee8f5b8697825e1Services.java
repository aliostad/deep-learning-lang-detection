package com.meeple.cloud.hivernage.service;

import com.meeple.cloud.hivernage.service.impl.CampingServiceMock;
import com.meeple.cloud.hivernage.service.impl.CaravaneServiceMock;
import com.meeple.cloud.hivernage.service.impl.ClientServiceMock;
import com.meeple.cloud.hivernage.service.impl.GabaritServiceMock;
import com.meeple.cloud.hivernage.service.impl.HangarServiceMock;
import com.meeple.cloud.hivernage.service.impl.HivernageServiceMock;
import com.meeple.cloud.hivernage.service.impl.TrancheServiceMock;

public class Services {

	public static final ICampingService campingService = new CampingServiceMock();
	public static final ICaravaneService caravaneService = new CaravaneServiceMock();
	public static final IClientService clientService = new ClientServiceMock();
	public static final IGabaritService gabaritService = new GabaritServiceMock();
	public static final IHangarService hangarService = new HangarServiceMock();
	public static final IHivernageService hivernageService = new HivernageServiceMock();
	public static final ITrancheService trancheService = new TrancheServiceMock();
	
}
