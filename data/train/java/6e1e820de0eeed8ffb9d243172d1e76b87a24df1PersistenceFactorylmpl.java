package nico.poetzl.projectpoetzl.app;

import java.util.HashMap;

import javax.persistence.EntityManager;

import nico.poetzl.projectpoetzl.repositoryjpa.AutoJpaRepository;
import nico.poetzl.projectpoetzl.repositoryjpa.FilialeJpaRepository;
import nico.poetzl.projectpoetzl.repositoryjpa.KaufJpaRepository;
import nico.poetzl.projectpoetzl.repositoryjpa.KundeJpaRepository;
import nico.poetzl.projectpoetzl.repositoryjpa.MitarbeiterJpaRepository;
import nico.poetzl.projectpoetzl.repositoryjpa.JpaRepository;
import nico.poetzl.projectpoetzl.repositoryjpa.PersistenceFactory;



public class PersistenceFactorylmpl implements PersistenceFactory {

    private final HashMap<Class<?>, JpaRepository> repositories = new HashMap<>();

    public PersistenceFactorylmpl(EntityManager entityManager) {
        AutoJpaRepository AutoJpaRepository = new AutoJpaRepository();
        AutoJpaRepository.setEntityManager(entityManager);
        repositories.put(AutoJpaRepository.class, AutoJpaRepository);

        FilialeJpaRepository FilialeJpaRepository = new FilialeJpaRepository();
        FilialeJpaRepository.setEntityManager(entityManager);
        repositories.put(FilialeJpaRepository.class, FilialeJpaRepository);

        KaufJpaRepository KaufJpaRepository = new KaufJpaRepository();
        KaufJpaRepository.setEntityManager(entityManager);
        repositories.put(KaufJpaRepository.class, KaufJpaRepository);

        KundeJpaRepository KundeJpaRepository = new KundeJpaRepository();
        KundeJpaRepository.setEntityManager(entityManager);
        repositories.put(KundeJpaRepository.class, KundeJpaRepository);

        MitarbeiterJpaRepository MitarbeiterJpaRepository = new MitarbeiterJpaRepository();
        MitarbeiterJpaRepository.setEntityManager(entityManager);
        repositories.put(MitarbeiterJpaRepository.class, MitarbeiterJpaRepository);

       
    }

    @Override
    public AutoJpaRepository AutoRepository() {
        return (AutoJpaRepository)repositories.get(AutoJpaRepository.class);
    }

    @Override
    public FilialeJpaRepository FilialeRepository() {
        return (FilialeJpaRepository)repositories.get(FilialeJpaRepository.class);
    }

    @Override
    public KaufJpaRepository KaufRepository() {
        return (KaufJpaRepository)repositories.get(KaufJpaRepository.class);
    }

    @Override
    public KundeJpaRepository KundeRepository() {
        return (KundeJpaRepository)repositories.get(KundeJpaRepository.class);
    }

    @Override
    public MitarbeiterJpaRepository MitarbeiterRepository() {
        return (MitarbeiterJpaRepository)repositories.get(MitarbeiterJpaRepository.class);
    }

   
}
