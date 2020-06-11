package at.haas.reparaturcenter.app;

import java.util.HashMap;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import at.haas.reparaturcenter.repositoryjpa.*;

public class PersistenceFactoryImpl implements PersistenceFactory {
	private final HashMap<Class<?>, JpaRepository> repositories = new HashMap<Class<?>, JpaRepository>();

    public PersistenceFactoryImpl(EntityManager entityManager) {
    	AutomarkeJpaRepository automarkeRepository = new AutomarkeJpaRepository();
    	automarkeRepository.setEntityManager(entityManager);
        repositories.put(AutomarkeJpaRepository.class, automarkeRepository);

        KundeJpaRepository kundeRepository = new KundeJpaRepository();
        kundeRepository.setEntityManager(entityManager);
        repositories.put(KundeJpaRepository.class, kundeRepository);

        MitarbeiterJpaRepository mitarbeiterRepository = new MitarbeiterJpaRepository();
        mitarbeiterRepository.setEntityManager(entityManager);
        repositories.put(MitarbeiterJpaRepository.class, mitarbeiterRepository);

        PersonJpaRepository personRepository = new PersonJpaRepository();
        personRepository.setEntityManager(entityManager);
        repositories.put(PersonJpaRepository.class, personRepository);

        ReparaturJpaRepository reparaturRepository = new ReparaturJpaRepository();
        reparaturRepository.setEntityManager(entityManager);
        repositories.put(ReparaturJpaRepository.class, reparaturRepository);
    }
    
    public AutomarkeJpaRepository automarkeRepository() {
		return (AutomarkeJpaRepository)repositories.get(AutomarkeJpaRepository.class);
	}

    public KundeJpaRepository kundeRepository() {
    	return (KundeJpaRepository)repositories.get(KundeJpaRepository.class);
	}

    public MitarbeiterJpaRepository mitarbeiterRepository() {
    	return (MitarbeiterJpaRepository)repositories.get(MitarbeiterJpaRepository.class);
	}

    public PersonJpaRepository personRepository() {
    	return (PersonJpaRepository)repositories.get(PersonJpaRepository.class);
	}

    public ReparaturJpaRepository reparaturRepository() {
    	return (ReparaturJpaRepository)repositories.get(ReparaturJpaRepository.class);
	}

}
