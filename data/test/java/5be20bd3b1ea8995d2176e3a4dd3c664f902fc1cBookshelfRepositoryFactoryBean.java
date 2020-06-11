package it.samvise85.bookshelf.persist.repository;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

public class BookshelfRepositoryFactoryBean<R extends JpaRepository<T, I>, T,I extends Serializable> extends JpaRepositoryFactoryBean<R, T, I> {

	protected RepositoryFactorySupport createRepositoryFactory(EntityManager em) {
		return new BookshelfRepositoryFactory<T, I>(em);
	}

	private static class BookshelfRepositoryFactory<T, I extends Serializable> extends JpaRepositoryFactory {
	    private final EntityManager em;

		public BookshelfRepositoryFactory(EntityManager em) {
			super(em);
			this.em = em;
		}

		@SuppressWarnings("unchecked")
		protected Object getTargetRepository(RepositoryMetadata metadata) {
			return new SearchRepositoryImpl<T, I>((Class<T>) metadata.getDomainType(), em);
		}

		protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
			return SearchRepositoryImpl.class;
		}
	}
}
