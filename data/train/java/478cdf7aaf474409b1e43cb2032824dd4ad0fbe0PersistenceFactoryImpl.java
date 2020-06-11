package timetable.app;

import timetable.repositoryjpa.JpaRepository;
import timetable.repositoryjpa.KaffeeJpaRepository;
import timetable.repositoryjpa.KundenJpaRepository;
import timetable.repositoryjpa.PersistenceFactory;
import timetable.repositoryjpa.TortenJpaRepository;

import java.util.HashMap;
import javax.persistence.EntityManager;

public class PersistenceFactoryImpl implements PersistenceFactory {

    private final HashMap<Class<?>, JpaRepository> repositories = new HashMap<Class<?>, JpaRepository>();

    public PersistenceFactoryImpl(EntityManager entityManager) {
      

        KundenJpaRepository kundenJpaRepository = new KundenJpaRepository();
        kundenJpaRepository.setEntityManager(entityManager);
        repositories.put(KundenJpaRepository.class, kundenJpaRepository);
        
        KaffeeJpaRepository kaffeeJpaRepository = new KaffeeJpaRepository();
        kaffeeJpaRepository.setEntityManager(entityManager);
        repositories.put(KaffeeJpaRepository.class, kaffeeJpaRepository);
        
        TortenJpaRepository tortenJpaRepository = new TortenJpaRepository();
        tortenJpaRepository.setEntityManager(entityManager);
        repositories.put(TortenJpaRepository.class, tortenJpaRepository);
        
    }
    
    


    public KundenJpaRepository kundenRepository() {
        return (KundenJpaRepository)repositories.get(KundenJpaRepository.class);
    }
    
   


	public KaffeeJpaRepository KaffeeRepository() {
		return (KaffeeJpaRepository)repositories.get(KaffeeJpaRepository.class);
	}



	public TortenJpaRepository TortenRepository() {
		return (TortenJpaRepository)repositories.get(TortenJpaRepository.class);
	}
}
