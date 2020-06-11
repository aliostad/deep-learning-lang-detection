package at.apa_it.ACD.app;

import java.util.HashMap;

import javax.persistence.EntityManager;

import at.apa_it.ACD.repositoryjpa.AuthTokenJpaRepository;
import at.apa_it.ACD.repositoryjpa.JpaRepository;
import at.apa_it.ACD.repositoryjpa.PersistenceFactory;
import at.apa_it.ACD.repositoryjpa.TenantJpaRepository;
import at.apa_it.ACD.repositoryjpa.UserJpaRepository;

public class PersistenceFactoryImpl implements PersistenceFactory {

    private final HashMap<Class<?>, JpaRepository> repositories = new HashMap<Class<?>, JpaRepository>();

    public PersistenceFactoryImpl(EntityManager entityManager) {
        UserJpaRepository userJpaRepository = new UserJpaRepository();
        userJpaRepository.setEntityManager(entityManager);
        repositories.put(UserJpaRepository.class, userJpaRepository);
    
        AuthTokenJpaRepository authTokenJpaRepository = new AuthTokenJpaRepository();
        authTokenJpaRepository.setEntityManager(entityManager);
        repositories.put(AuthTokenJpaRepository.class, authTokenJpaRepository);
    
        TenantJpaRepository tenantJpaRepository = new TenantJpaRepository();
        tenantJpaRepository.setEntityManager(entityManager);
        repositories.put(TenantJpaRepository.class, tenantJpaRepository);
    }

	public UserJpaRepository userJpaRepository() {
		return (UserJpaRepository) repositories.get(UserJpaRepository.class);
	}

	public TenantJpaRepository tenantJpaRepository() {
		return (TenantJpaRepository) repositories.get(TenantJpaRepository.class);
	}

	public AuthTokenJpaRepository authTokenJpaRepository() {
		return (AuthTokenJpaRepository) repositories.get(AuthTokenJpaRepository.class);
	}
    
    
}
