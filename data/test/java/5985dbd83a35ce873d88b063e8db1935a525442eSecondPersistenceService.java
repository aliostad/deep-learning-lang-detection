/**
 * 
 */
package gr.ekt.cerif.services.second;

import gr.ekt.cerif.entities.link.FederatedIdentifier_Class;
import gr.ekt.cerif.entities.link.Service_FederatedIdentifier;
import gr.ekt.cerif.entities.second.FederatedIdentifier;
import gr.ekt.cerif.services.link.federatedidentifier.LinkFederatedIdentifierClassRepository;
import gr.ekt.cerif.services.link.service.LinkServiceFederatedIdentifierRepository;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Persistence service for CERIF 2nd Level Entities.
 * 
 */
@Component
public class SecondPersistenceService {
	
	/**
	 * The citation repository.
	 */
	@Autowired
	private CitationRepository citationRepository;
	
	/**
	 * The country repository.
	 */
	@Autowired
	private CountryRepository countryRepository;
	
	/**
	 * The currency repository.
	 */
	@Autowired
	private CurrencyRepository currencyRepository;
	
	/**
	 * The curriculum vitae repository.
	 */
	@Autowired
	private CurriculumVitaeRepository curriculumVitaeRepository;
	
	/**
	 * The electronic address repository.
	 */
	@Autowired
	private ElectronicAddressRepository electronicAddressRepository;
	
	/**
	 * The event repository.
	 */
	@Autowired
	private EventRepository eventRepository;
	
	/**
	 * The expertise and skills repository.
	 */
	@Autowired
	private ExpertiseAndSkillsRepository expertiseAndSkillsRepository;
	
	
	/**
	 * The federated identifier repository.
	 */
	@Autowired
	private FederatedIdentifierRepository federatedIdentifierRepository;
	
	/**
	 * The funding repository.
	 */
	@Autowired
	private FundingRepository fundingRepository;
	
	/**
	 * The geographic bounding box repository.
	 */
	@Autowired
	private GeographicBoundingBoxRepository geographicBoundingBoxRepository;
	
	/**
	 * The indicator repository.
	 */
	@Autowired
	private IndicatorRepository indicatorRepository;
	
	/**
	 * The language repository.
	 */
	@Autowired
	private LanguageRepository languageRepository;
	
	/**
	 * The measurement repository.
	 */
	@Autowired
	private MeasurementRepository measurementRepository;
	
	/**
	 * The medium repository.
	 */
	@Autowired
	private MediumRepository mediumRepository;
	
	/**
	 * The metrics repository.
	 */
	@Autowired
	private MetricsRepository metricsRepository;
	
	/**
	 * The postal address repository.
	 */
	@Autowired
	private PostalAddressRepository postalAddressRepository;
	
	/**
	 * The prize repository.
	 */
	@Autowired
	private PrizeRepository prizeRepository;
	
	/**
	 * The qualification repository.
	 */
	@Autowired
	private QualificationRepository qualificationRepository;	
	
	/**
	 * Service for links between federated identifiers and services.
	 */
	@Autowired
	private LinkServiceFederatedIdentifierRepository serviceFederatedIdentifierRepository;
	
	/**
	 * Service for links between federated identifiers and classes.
	 */
	@Autowired
	private LinkFederatedIdentifierClassRepository federatedIdentifierClassRepository;
	
	
	
	/**
	 * Retrieves the federated identifiers of an entity, including the class and service links.
	 * @param uuidType The entity type UUID.
	 * @param instanceId The entity id.
	 * @return a list of federated identifiers.
	 */
	public List<FederatedIdentifier> getFederatedIdentifiersForEntity(String uuidType, Long instanceId) {
		List<FederatedIdentifier> fedIds = getFederatedIdentifierRepository().findFedIdByClassUuidAndInstId(uuidType, instanceId);
		for (FederatedIdentifier fedId: fedIds) {
			//classes
			List<FederatedIdentifier_Class> federatedIdentifierClasses = federatedIdentifierClassRepository.findByFederatedIdentifier(fedId);
			Set<FederatedIdentifier_Class> fedClasses = new HashSet<FederatedIdentifier_Class>(federatedIdentifierClasses);
			fedId.setFederatedIdentifiers_classes(fedClasses);
				
			//services
			List<Service_FederatedIdentifier> federatedIdentifierServices = serviceFederatedIdentifierRepository.findByFederatedIdentifier(fedId);
			Set<Service_FederatedIdentifier> fedServices = new HashSet<Service_FederatedIdentifier>(federatedIdentifierServices);
			fedId.setServices_federatedIdentifiers(fedServices);
		}
		return fedIds;
	}

	/**
	 * @return the citationRepository
	 */
	public CitationRepository getCitationRepository() {
		return citationRepository;
	}

	/**
	 * @return the countryRepository
	 */
	public CountryRepository getCountryRepository() {
		return countryRepository;
	}

	/**
	 * @return the currencyRepository
	 */
	public CurrencyRepository getCurrencyRepository() {
		return currencyRepository;
	}
	
	/**
	 * @return the curriculumVitaeRepository
	 */
	public CurriculumVitaeRepository getCurriculumVitaeRepository() {
		return curriculumVitaeRepository;
	}

	/**
	 * @return the serviceFederatedIdentifierRepository
	 */
	public LinkServiceFederatedIdentifierRepository getServiceFederatedIdentifierRepository() {
		return serviceFederatedIdentifierRepository;
	}

	/**
	 * @return the federatedIdentifierClassRepository
	 */
	public LinkFederatedIdentifierClassRepository getFederatedIdentifierClassRepository() {
		return federatedIdentifierClassRepository;
	}

	/**
	 * @return the electronicRepository
	 */
	public ElectronicAddressRepository getElectronicAddressRepository() {
		return electronicAddressRepository;
	}

	/**
	 * @return the eventRepository
	 */
	public EventRepository getEventRepository() {
		return eventRepository;
	}

	/**
	 * @return the expertiseAndSkillsRepository
	 */
	public ExpertiseAndSkillsRepository getExpertiseAndSkillsRepository() {
		return expertiseAndSkillsRepository;
	}
	
	public FederatedIdentifierRepository getFederatedIdentifierRepository() {
		return federatedIdentifierRepository;
	}

	/**
	 * @return the fundingRepository
	 */
	public FundingRepository getFundingRepository() {
		return fundingRepository;
	}

	/**
	 * @return the geographicBoundingBoxRepository
	 */
	public GeographicBoundingBoxRepository getGeographicBoundingBoxRepository() {
		return geographicBoundingBoxRepository;
	}

	/**
	 * @return the indicatorRepository
	 */
	public IndicatorRepository getIndicatorRepository() {
		return indicatorRepository;
	}

	/**
	 * @return the languageRepository
	 */
	public LanguageRepository getLanguageRepository() {
		return languageRepository;
	}

	/**
	 * @return the measurementRepository
	 */
	public MeasurementRepository getMeasurementRepository() {
		return measurementRepository;
	}

	/**
	 * @return the mediumRepository
	 */
	public MediumRepository getMediumRepository() {
		return mediumRepository;
	}

	/**
	 * @return the metricsRepository
	 */
	public MetricsRepository getMetricsRepository() {
		return metricsRepository;
	}

	/**
	 * @return the postalRepository
	 */
	public PostalAddressRepository getPostalAddressRepository() {
		return postalAddressRepository;
	}

	/**
	 * @return the prizeRepository
	 */
	public PrizeRepository getPrizeRepository() {
		return prizeRepository;
	}

	/**
	 * @return the qualificationRepository
	 */
	public QualificationRepository getQualificationRepository() {
		return qualificationRepository;
	}
	
	

}
