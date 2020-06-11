package at.fdisk.core.app;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.EntityManager;

import at.fdisk.core.repositoryjpa.AusbildungJpaRepository;
import at.fdisk.core.repositoryjpa.AusruestungJpaRepository;
import at.fdisk.core.repositoryjpa.BerechtigungJpaRepository;
import at.fdisk.core.repositoryjpa.ChargeJpaRepository;
import at.fdisk.core.repositoryjpa.FeuerwehrJpaRepository;
import at.fdisk.core.repositoryjpa.FeuerwehrautoJpaRepository;
import at.fdisk.core.repositoryjpa.GeraetJpaRepository;
import at.fdisk.core.repositoryjpa.JpaRepository;
import at.fdisk.core.repositoryjpa.MitgliedJpaRepository;
import at.fdisk.core.repositoryjpa.PersistenceFactory;
import at.fdisk.core.repositoryjpa.UserJpaRepository;

public class PersistenceFactoryImpl implements PersistenceFactory {

    private final Map<Class<?>, JpaRepository> repositories = new HashMap<>();
    
    public PersistenceFactoryImpl(EntityManager entityManager){
    	AusbildungJpaRepository ausbildungJPARepository = new AusbildungJpaRepository();
    	ausbildungJPARepository.setEntityManager(entityManager);
    	repositories.put(AusbildungJpaRepository.class, ausbildungJPARepository);
    	
    	AusruestungJpaRepository ausruestungJPARepository = new AusruestungJpaRepository();
    	ausruestungJPARepository.setEntityManager(entityManager);
    	repositories.put(AusruestungJpaRepository.class, ausruestungJPARepository);
    	
    	BerechtigungJpaRepository berechtigungRepository = new BerechtigungJpaRepository();
    	berechtigungRepository.setEntityManager(entityManager);
    	repositories.put(BerechtigungJpaRepository.class, berechtigungRepository);
    	
    	ChargeJpaRepository chargeRepository = new ChargeJpaRepository();
    	chargeRepository.setEntityManager(entityManager);
    	repositories.put(ChargeJpaRepository.class, chargeRepository);
    	
    	FeuerwehrJpaRepository feuerwehrRepository = new FeuerwehrJpaRepository();
    	feuerwehrRepository.setEntityManager(entityManager);
    	repositories.put(FeuerwehrJpaRepository.class, feuerwehrRepository);
    	
    	FeuerwehrautoJpaRepository feuerwehrautoRepository = new FeuerwehrautoJpaRepository();
    	feuerwehrautoRepository.setEntityManager(entityManager);
    	repositories.put(FeuerwehrautoJpaRepository.class, feuerwehrautoRepository);
    	
    	GeraetJpaRepository geraeteRepository = new GeraetJpaRepository();
    	geraeteRepository.setEntityManager(entityManager);
    	repositories.put(GeraetJpaRepository.class, geraeteRepository);
    	
    	MitgliedJpaRepository mitgliedRepository = new MitgliedJpaRepository();
    	mitgliedRepository.setEntityManager(entityManager);
    	repositories.put(MitgliedJpaRepository.class, mitgliedRepository);
    	
    	UserJpaRepository userRepository = new UserJpaRepository();
    	userRepository.setEntityManager(entityManager);
    	repositories.put(UserJpaRepository.class, userRepository);
    }
    
	public AusbildungJpaRepository ausbildungsRepository() {
		return (AusbildungJpaRepository)repositories.get(AusbildungJpaRepository.class);
	}

	public AusruestungJpaRepository ausruestungRepository() {
		return (AusruestungJpaRepository)repositories.get(AusruestungJpaRepository.class);
	}
	
	public BerechtigungJpaRepository berechtigungRepository() {
		return (BerechtigungJpaRepository)repositories.get(BerechtigungJpaRepository.class);
	}

	public ChargeJpaRepository chargeRepostitory() {
		return (ChargeJpaRepository)repositories.get(ChargeJpaRepository.class);
	}

	public FeuerwehrautoJpaRepository feuerwehrautoRepository() {
		return (FeuerwehrautoJpaRepository)repositories.get(FeuerwehrautoJpaRepository.class);
	}

	public FeuerwehrJpaRepository feuerwehrRepository() {
		return (FeuerwehrJpaRepository)repositories.get(FeuerwehrJpaRepository.class);
	}

	public GeraetJpaRepository geraeteRepository() {
		return (GeraetJpaRepository)repositories.get(GeraetJpaRepository.class);
	}

	public MitgliedJpaRepository mitgliedRepository() {
		return (MitgliedJpaRepository)repositories.get(MitgliedJpaRepository.class);
	}
	
	public UserJpaRepository userRepository(){
		return (UserJpaRepository)repositories.get(UserJpaRepository.class);
	}
}
