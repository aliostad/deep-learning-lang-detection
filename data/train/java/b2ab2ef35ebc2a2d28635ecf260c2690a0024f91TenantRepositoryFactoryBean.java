package cn.aolc.group.performance.tenant;

import java.io.Serializable;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.criteria.CriteriaQuery;

import org.springframework.aop.framework.ProxyFactory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.JpaQueryMethod;
import org.springframework.data.jpa.repository.query.PartTreeJpaQuery;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.core.RepositoryInformation;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.data.repository.core.support.QueryCreationListener;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;
import org.springframework.data.repository.core.support.RepositoryProxyPostProcessor;
import org.springframework.data.repository.query.Parameters;
import org.springframework.data.repository.query.QueryMethod;
import org.springframework.data.repository.query.RepositoryQuery;

public class TenantRepositoryFactoryBean<R extends JpaRepository<T, I>, T, I extends Serializable>
extends JpaRepositoryFactoryBean<R, T, I> {
	
	protected RepositoryFactorySupport  createRepositoryFactory(EntityManager entityManager) {

		final MyRepositoryFactory fac=new MyRepositoryFactory(entityManager);
		
		fac.addQueryCreationListener(new QueryCreationListener<RepositoryQuery>() {

			public void onCreation(RepositoryQuery query) {
				
			}
		});
		
		fac.addRepositoryProxyPostProcessor(new RepositoryProxyPostProcessor() {
			
			public void postProcess(ProxyFactory factory,
					RepositoryInformation repositoryInformation) {
				
				//logger.info("addRepositoryProxyPostProcessor "+repositoryInformation.getDomainType().getSimpleName());
			}
		});
		
	    return fac;
	  }

	  private static class MyRepositoryFactory<T, I extends Serializable> extends JpaRepositoryFactory {

	    private EntityManager entityManager;

	    public MyRepositoryFactory(EntityManager entityManager) {
	      super(entityManager);

	      this.entityManager = entityManager;
	    }

	    protected Object getTargetRepository(RepositoryMetadata metadata) {

	      return new TenantSimpleRepository((Class<T>) metadata.getDomainType(), entityManager);
	    }

	    protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
	  
	      return TenantSimpleRepository.class;
	    }
	  }
	  
	  
	 
}
