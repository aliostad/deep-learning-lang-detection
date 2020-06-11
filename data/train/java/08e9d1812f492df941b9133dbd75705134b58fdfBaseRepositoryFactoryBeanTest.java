package com.packtpub.springdata.jpa.repository;

import com.packtpub.springdata.jpa.config.PersistenceTestContext;
import com.packtpub.springdata.jpa.model.Contact;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.JpaMetamodelEntityInformation;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.data.repository.core.support.DefaultRepositoryMetadata;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import static junit.framework.Assert.assertEquals;

/**
 * @author Petri Kainulainen
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {PersistenceTestContext.class})
public class BaseRepositoryFactoryBeanTest {

    @PersistenceContext
    private EntityManager entityManager;

    private BaseRepositoryFactoryBean repositoryFactoryBean;

    @Before
    public void setUp() {
        repositoryFactoryBean = new BaseRepositoryFactoryBean();
    }

    @Test
    public void createRepositoryFactory() {
        RepositoryFactorySupport repositoryFactory = repositoryFactoryBean.createRepositoryFactory(entityManager);
        assertEquals(BaseRepositoryFactoryBean.BaseRepositoryFactory.class, repositoryFactory.getClass());
    }

    @Test
    public void getRepositoryBaseClass() {
        BaseRepositoryFactoryBean.BaseRepositoryFactory repositoryFactory = (BaseRepositoryFactoryBean.BaseRepositoryFactory) repositoryFactoryBean.createRepositoryFactory(entityManager);
        RepositoryMetadata metaData = buildRepositoryMetadata();
        assertEquals(GenericBaseRepository.class, repositoryFactory.getRepositoryBaseClass(metaData));
    }

    @Test
    public void getTargetRepository() {
        BaseRepositoryFactoryBean.BaseRepositoryFactory repositoryFactory = (BaseRepositoryFactoryBean.BaseRepositoryFactory) repositoryFactoryBean.createRepositoryFactory(entityManager);
        RepositoryMetadata metaData = buildRepositoryMetadata();
        assertEquals(GenericBaseRepository.class, repositoryFactory.getTargetRepository(metaData).getClass());
    }

    private RepositoryMetadata buildRepositoryMetadata() {
        return new DefaultRepositoryMetadata(ContactRepository.class);
    }
}
