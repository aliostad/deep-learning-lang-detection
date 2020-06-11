package com.nextplus.housetolet.service.impl;

import org.springframework.beans.factory.annotation.Autowired;

import com.nextplus.housetolet.repository.PaymentRepository;
import com.nextplus.housetolet.repository.RentalRepository;
import com.nextplus.housetolet.repository.RoomRepository;
import com.nextplus.housetolet.repository.UserRepository;

public class BaseService  {
	
	@Autowired
	protected UserRepository userRepository;
	@Autowired
	protected PaymentRepository paymentRepository;
	@Autowired
	protected RentalRepository rentalRepository;
	@Autowired
	protected RoomRepository roomRepository;

}
