package infrastructure.hib;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import core.contract.infracontract.IApplianceRepository;
import core.contract.infracontract.IAvailableTimeRepository;
import core.contract.infracontract.IBookedTimeRepository;
import core.contract.infracontract.ICityRepository;
import core.contract.infracontract.ICountryRepository;
import core.contract.infracontract.IDistrictRepository;
import core.contract.infracontract.IEstateFeatureRepository;
import core.contract.infracontract.IEstateRepository;
import core.contract.infracontract.IExpertAgencyRepository;
import core.contract.infracontract.IImageRepository;
import core.contract.infracontract.INearbyFacilityRepository;
import core.contract.infracontract.IOfferRepository;
import core.contract.infracontract.IPieceRepository;
import core.contract.infracontract.IRETypeRepository;
import core.contract.infracontract.IRepresenterRepository;
import core.contract.infracontract.IRoleRepository;
import core.contract.infracontract.ISellingOfferRepository;
import core.contract.infracontract.IStateRepository;
import core.contract.infracontract.IUnitOfWork;
import core.contract.infracontract.IUnitRepository;
import core.contract.infracontract.IUserRepository;

@Component
public class UnitOfWork  implements IUnitOfWork {

	private Session session;
	private Transaction transaction;
	private ICityRepository cityRepository;
	private IRoleRepository roleRepository;
	private IUserRepository userRepository;
	private IExpertAgencyRepository expertAgencyRepository;
	private ICountryRepository countryRepository;
	private IDistrictRepository districtRepository;
	private IStateRepository stateRepository;
	private IApplianceRepository applianceRepository;
	private IEstateRepository estateRepository;
	private IEstateFeatureRepository estateFeatureRepository;
	private IImageRepository imageRepository;
	private INearbyFacilityRepository nearbyFacilityRepository;
	private IPieceRepository pieceRepository;
	private IUnitRepository unitRepository;
	private IAvailableTimeRepository availableTimeRepository;
	private IBookedTimeRepository bookedTimeRepository;
	private IOfferRepository offerRepository;
	private IRepresenterRepository representerRepository;
	private ISellingOfferRepository sellingOfferRepository;
	private IRETypeRepository rETypeRepository;
	

	public UnitOfWork() {
		this.session = HibernateUtility.getSessionFactory().openSession();
		this.transaction = session.beginTransaction();
	}

	@Override
	public void close() {
		this.session.close();
	}

	@Override
	public void commit() {
		this.transaction.commit();
		close();
	}

	@Override
	public void rollback() {
		this.transaction.rollback();
		close();
	}
	
	public Session getSession() {
		return session;
	}

	public void setSession(Session session) {
		this.session = session;
	}

	public Transaction getTransaction() {
		return transaction;
	}

	public void setTransaction(Transaction transaction) {
		this.transaction = transaction;
	}

	@Override
	public ICityRepository getCityRepository() {
		return cityRepository;
	}

	@Autowired
	public void setCityRepository(ICityRepository cityRepository) {
		this.cityRepository = cityRepository;
		this.cityRepository.setObject(this.session);
	}
	
	@Override
	public IRoleRepository getRoleRepository() {
		return roleRepository;
	}
	
	@Autowired
	public void setRoleRepository(IRoleRepository roleRepository) {
		this.roleRepository = roleRepository;
		this.roleRepository.setObject(this.session);
	}

	@Override
	public IUserRepository getUserRepository() {
		return userRepository;
	}
	
	@Autowired
	public void setUserRepository(IUserRepository userRepository) {
		this.userRepository = userRepository;
		this.userRepository.setObject(this.session);
	}

	@Override
	public IExpertAgencyRepository getExpertAgencyRepository() {
		return expertAgencyRepository;
	}
	
	@Autowired
	public void setExpertAgencyRepository(
			IExpertAgencyRepository expertAgencyRepository) {
		this.expertAgencyRepository = expertAgencyRepository;
		this.expertAgencyRepository.setObject(this.session);
	}

	@Override
	public ICountryRepository getCountryRepository() {
		return countryRepository;
	}
	
	@Autowired
	public void setCountryRepository(ICountryRepository countryRepository) {
		this.countryRepository = countryRepository;
		this.countryRepository.setObject(this.session);
	}

	@Override
	public IDistrictRepository getDistrictRepository() {
		return districtRepository;
	}
	
	@Autowired
	public void setDistrictRepository(IDistrictRepository districtRepository) {
		this.districtRepository = districtRepository;
		this.districtRepository.setObject(this.session);
	}

	
	@Override
	public IStateRepository getStateRepository() {
		return stateRepository;
	}
	
	@Autowired
	public void setStateRepository(IStateRepository stateRepository) {
		this.stateRepository = stateRepository;
		this.stateRepository.setObject(this.session);
	}

	@Override
	public IApplianceRepository getApplianceRepository() {
		return applianceRepository;
	}
	
	@Autowired
	public void setApplianceRepository(IApplianceRepository applianceRepository) {
		this.applianceRepository = applianceRepository;
		this.applianceRepository.setObject(this.session);
	}
	
	@Override
	public IEstateRepository getEstateRepository() {
		return estateRepository;
	}
	
	@Autowired
	public void setEstateRepository(IEstateRepository estateRepository) {
		this.estateRepository = estateRepository;
		this.estateRepository.setObject(this.session);
	}

	@Override
	public IEstateFeatureRepository getEstateFeatureRepository() {
		return estateFeatureRepository;
	}
	
	@Autowired
	public void setEstateFeatureRepository(
			IEstateFeatureRepository estateFeatureRepository) {
		this.estateFeatureRepository = estateFeatureRepository;
		this.estateFeatureRepository.setObject(this.session);
	}
	
	@Override
	public IImageRepository getImageRepository() {
		return imageRepository;
	}
	
	@Autowired
	public void setImageRepository(IImageRepository imageRepository) {
		this.imageRepository = imageRepository;
		this.imageRepository.setObject(this.session);
	}
	
	@Override
	public INearbyFacilityRepository getNearbyFacilityRepository() {
		return nearbyFacilityRepository;
	}
	
	@Autowired
	public void setNearbyFacilityRepository(
			INearbyFacilityRepository nearbyFacilityRepository) {
		this.nearbyFacilityRepository = nearbyFacilityRepository;
		this.nearbyFacilityRepository.setObject(this.session);
	}
	
	@Override
	public IPieceRepository getPieceRepository() {
		return pieceRepository;
	}
	
	@Autowired
	public void setPieceRepository(IPieceRepository pieceRepository) {
		this.pieceRepository = pieceRepository;
		this.pieceRepository.setObject(this.session);
	}
	
	@Override
	public IUnitRepository getUnitRepository() {
		return unitRepository;
	}
	
	@Autowired
	public void setUnitRepository(IUnitRepository unitRepository) {
		this.unitRepository = unitRepository;
		this.unitRepository.setObject(this.session);
	}

	@Override
	public IAvailableTimeRepository getAvailableTimeRepository() {
		return availableTimeRepository;
	}
	
	@Autowired
	public void setAvailableTimeRepository(
			IAvailableTimeRepository availableTimeRepository) {
		this.availableTimeRepository = availableTimeRepository;
		this.availableTimeRepository.setObject(this.session);
	}

	@Override
	public IBookedTimeRepository getBookedTimeRepository() {
		return bookedTimeRepository;
	}
	
	@Autowired
	public void setBookedTimeRepository(IBookedTimeRepository bookedTimeRepository) {
		this.bookedTimeRepository = bookedTimeRepository;
		this.bookedTimeRepository.setObject(this.session);
	}

	@Override
	public IOfferRepository getOfferRepository() {
		return offerRepository;
	}
	
	@Autowired
	public void setOfferRepository(IOfferRepository offerRepository) {
		this.offerRepository = offerRepository;
		this.offerRepository.setObject(this.session);
	}

	@Override
	public IRepresenterRepository getRepresenterRepository() {
		return representerRepository;
	}
	
	@Autowired
	public void setRepresenterRepository(
			IRepresenterRepository representerRepository) {
		this.representerRepository = representerRepository;
		this.representerRepository.setObject(this.session);
	}

	@Override
	public ISellingOfferRepository getSellingOfferRepository() {
		return sellingOfferRepository;
	}
	
	@Autowired
	public void setSellingOfferRepository(
			ISellingOfferRepository sellingOfferRepository) {
		this.sellingOfferRepository = sellingOfferRepository;
		this.sellingOfferRepository.setObject(this.session);
	}

	@Override
	public IRETypeRepository getrETypeRepository() {
		return rETypeRepository;
	}
	
	@Autowired
	public void setrETypeRepository(IRETypeRepository rETypeRepository) {
		this.rETypeRepository = rETypeRepository;
		this.rETypeRepository.setObject(this.session);
	}

}
