package basar.domain;

class SaleServiceImpl implements SaleService {
	
	/** 
	 * @uml.property name="positionRepository"
	 * @uml.associationEnd multiplicity="(1 1)" aggregation="shared" inverse="saleServiceImpl:basar.domain.PositionRepository"
	 */
	private PositionRepository positionRepository = DomainBasarFactory.instance.createPositionRepository();

	/** 
	 * @uml.property name="sellerRepository"
	 * @uml.associationEnd multiplicity="(1 1)" aggregation="shared" inverse="saleServiceImpl:basar.domain.SellerRepository"
	 */
	private SellerRepository sellerRepository = DomainBasarFactory.instance.createSellerRepository();

	/** 
	 * Getter of the property <tt>positionRepository</tt>
	 * @return  Returns the positionRepository.
	 * @uml.property  name="positionRepository"
	 */
	public PositionRepository getPositionRepository() {
		return positionRepository;
	}

	/** 
	 * Getter of the property <tt>sellerRepository</tt>
	 * @return  Returns the sellerRepository.
	 * @uml.property  name="sellerRepository"
	 */
	public SellerRepository getSellerRepository() {
		return sellerRepository;
	}

	public boolean isValideBasarNumber(long number) {
		return false;
	}

	public void purchase(Sale sale) {
	}

	/** 
	 * Setter of the property <tt>positionRepository</tt>
	 * @param positionRepository  The positionRepository to set.
	 * @uml.property  name="positionRepository"
	 */
	public void setPositionRepository(PositionRepository positionRepository) {
		this.positionRepository = positionRepository;
	}

	/** 
	 * Setter of the property <tt>sellerRepository</tt>
	 * @param sellerRepository  The sellerRepository to set.
	 * @uml.property  name="sellerRepository"
	 */
	public void setSellerRepository(SellerRepository sellerRepository) {
		this.sellerRepository = sellerRepository;
	}

	public void storno(Sale sale) {
	}


}
