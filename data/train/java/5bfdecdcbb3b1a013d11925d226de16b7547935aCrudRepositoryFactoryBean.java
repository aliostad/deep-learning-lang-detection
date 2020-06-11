package transactional.repository.issues.repro.factory;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

public class CrudRepositoryFactoryBean<T extends CrudRepository<S, ID>, S, ID extends Serializable>
        extends JpaRepositoryFactoryBean<T, S, ID> {

	@Override
	protected RepositoryFactorySupport createRepositoryFactory(
	        EntityManager entityManager) {
		return new CrudRepositoryFactory(entityManager);
	}

}
