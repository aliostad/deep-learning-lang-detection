package ar.edu.itba.it.paw.hotelapp.repositories.impl;

import ar.edu.itba.it.paw.hotelapp.repositories.api.HotelRepository;
import ar.edu.itba.it.paw.hotelapp.repositories.api.UserRepository;
import ar.edu.itba.it.paw.hotelapp.repositories.base.HotelRepositoryTest;

public class SQLHotelRepositoryTest extends HotelRepositoryTest {

	private HotelRepository repository;
	private UserRepository userRepository;

	@Override
	public HotelRepository getRepository() {
		if (this.repository == null) {
			this.repository = new SQLHotelRepository(this.getDispatcher(),
					this.getUserRepository());
		}
		return this.repository;
	}

	@Override
	public UserRepository getUserRepository() {
		if (this.userRepository == null) {
			this.userRepository = new SQLUserRepository(this.getDispatcher());
		}
		return this.userRepository;
	}
}
