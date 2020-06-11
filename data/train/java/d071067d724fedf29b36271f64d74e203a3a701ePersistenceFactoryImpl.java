package app;

import repositoryjpa.*;

import javax.persistence.EntityManager;
import java.util.HashMap;

/**
 * Created by viktor on 3/26/14.
 */
public class PersistenceFactoryImpl implements PersistenceFactory{

    private final HashMap<Class<?>, JPARepository> repositories = new HashMap<>();

    public PersistenceFactoryImpl(EntityManager entityManager) {
        FachRepositoryJPA fachRepositoryJPA=new FachRepositoryJPA();
        fachRepositoryJPA.setEntityManager(entityManager);
        repositories.put(FachRepositoryJPA.class, fachRepositoryJPA);

        KlasseRepositoryJPA klasseRepositoryJPA=new KlasseRepositoryJPA();
        klasseRepositoryJPA.setEntityManager(entityManager);
        repositories.put(KlasseRepositoryJPA.class, klasseRepositoryJPA);

        LehrerRepositoryJPA lehrerRepositoryJPA=new LehrerRepositoryJPA();
        lehrerRepositoryJPA.setEntityManager(entityManager);
        repositories.put(LehrerRepositoryJPA.class, lehrerRepositoryJPA);

        SchuelerRepositoryJPA schuelerRepositoryJPA=new SchuelerRepositoryJPA();
        schuelerRepositoryJPA.setEntityManager(entityManager);
        repositories.put(SchuelerRepositoryJPA.class, schuelerRepositoryJPA);
    }

    @Override
    public FachRepositoryJPA fachRepository() {
        return (FachRepositoryJPA) repositories.get(FachRepositoryJPA.class);
    }

    @Override
    public KlasseRepositoryJPA klasseRepository() {
        return (KlasseRepositoryJPA) repositories.get(KlasseRepositoryJPA.class);
    }

    @Override
    public LehrerRepositoryJPA lehrerRepository() {
        return (LehrerRepositoryJPA) repositories.get(LehrerRepositoryJPA.class);
    }

    @Override
    public SchuelerRepositoryJPA schuelerRepository() {
        return (SchuelerRepositoryJPA) repositories.get(SchuelerRepositoryJPA.class);
    }
}
