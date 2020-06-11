package com.taxi.repository.factory.hibernate;

import com.taxi.repository.TaxiCarRepository;
import com.taxi.repository.TaxiDriverRepository;
import com.taxi.repository.TaxiParkRepository;
import com.taxi.repository.factory.RepositoryFactory;
import com.taxi.repository.hibernate.HibernateTaxiCarRepository;
import com.taxi.repository.hibernate.HibernateTaxiDriverRepository;
import com.taxi.repository.hibernate.HibernateTaxiParkRepository;
import com.taxi.utils.SessionFactoryHolder;

public class HibernateRepositoryFactory implements RepositoryFactory {

	private static RepositoryFactory repositoryFactory;

	private TaxiParkRepository taxiParkRepository;
	private TaxiCarRepository taxiCarRepository;
	private TaxiDriverRepository taxiDriverRepository;

	public static RepositoryFactory getFactory() {
		if (repositoryFactory == null) {
			repositoryFactory = new HibernateRepositoryFactory();
		}
		return repositoryFactory;
	}

	@Override
	public TaxiParkRepository getTaxiParkRepository() {
		if (taxiParkRepository == null) {
			taxiParkRepository = new HibernateTaxiParkRepository(
					SessionFactoryHolder.getSessionFactory());
		}
		return taxiParkRepository;
	}

	@Override
	public TaxiCarRepository getCarRepository() {
		if (taxiCarRepository == null) {
			taxiCarRepository = new HibernateTaxiCarRepository(
					SessionFactoryHolder.getSessionFactory());
		}
		return taxiCarRepository;
	}

	@Override
	public TaxiDriverRepository getDriverRepository() {
		if (taxiDriverRepository == null) {
			taxiDriverRepository = new HibernateTaxiDriverRepository(
					SessionFactoryHolder.getSessionFactory());
		}
		return taxiDriverRepository;
	}

}
