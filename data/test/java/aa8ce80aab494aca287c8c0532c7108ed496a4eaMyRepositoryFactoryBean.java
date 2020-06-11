package com.aerohive.wsm;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

import com.aerohive.wsm.dao.impl.MyRepositoryImpl;

/**
 * Then create a custom repository factory to replace the default
 * RepositoryFactoryBean that will in turn produce a custom RepositoryFactory.
 * The new repository factory will then provide your MyRepositoryImpl as the
 * implementation of any interfaces that extend the Repository interface,
 * replacing the SimpleJpaRepository implementation you just extended.
 * 
 * @author smwang
 * 
 * @param <R>
 * @param <T>
 * @param <I>
 */
public class MyRepositoryFactoryBean<R extends JpaRepository<T, I>, T, I extends Serializable>
		extends JpaRepositoryFactoryBean<R, T, I> {

	@Override
	protected RepositoryFactorySupport createRepositoryFactory(EntityManager em) {
		return new MyRepositoryFactory(em);
	}

	private static class MyRepositoryFactory<T, I extends Serializable> extends
			JpaRepositoryFactory {

		private final EntityManager em;

		public MyRepositoryFactory(EntityManager em) {

			super(em);
			this.em = em;
		}

		@Override
		protected <U, ID extends Serializable> org.springframework.data.jpa.repository.support.SimpleJpaRepository<?, ?> getTargetRepository(
				RepositoryMetadata metadata, EntityManager entityManager) {
			System.out.println("metadata=" + metadata);
			return new MyRepositoryImpl(
					getEntityInformation(metadata.getDomainType()),
					entityManager);
		};

		protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
			return MyRepositoryImpl.class;
		}
	}
}
