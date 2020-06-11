package core.contract.infracontract;


public interface IUnitOfWork  extends AutoCloseable {
	public void commit();
	public void rollback();

	public ICityRepository getCityRepository();
	public IRETypeRepository getrETypeRepository();
	public ISellingOfferRepository getSellingOfferRepository();
	public IRepresenterRepository getRepresenterRepository();
	public IOfferRepository getOfferRepository();
	public IBookedTimeRepository getBookedTimeRepository();
	public IAvailableTimeRepository getAvailableTimeRepository();
	public IUnitRepository getUnitRepository();
	public IPieceRepository getPieceRepository();
	public INearbyFacilityRepository getNearbyFacilityRepository();
	public IImageRepository getImageRepository();
	public IEstateFeatureRepository getEstateFeatureRepository();
	public IEstateRepository getEstateRepository();
	public IApplianceRepository getApplianceRepository();
	public IStateRepository getStateRepository();
	public IDistrictRepository getDistrictRepository();
	public ICountryRepository getCountryRepository();
	public IExpertAgencyRepository getExpertAgencyRepository();
	public IUserRepository getUserRepository();
	public IRoleRepository getRoleRepository();

}
