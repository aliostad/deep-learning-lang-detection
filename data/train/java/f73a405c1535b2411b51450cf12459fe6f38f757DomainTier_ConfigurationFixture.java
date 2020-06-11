package com.processpuzzle.sharedfixtures.domaintier;

import org.mockito.MockitoAnnotations;
import org.mockito.Mock;

import com.processpuzzle.address.domain.CountryRepository;
import com.processpuzzle.address.domain.SettlementRepository;
import com.processpuzzle.address.domain.ZipCodeRepository;
import com.processpuzzle.application.configuration.domain.ApplicationContextFactory;
import com.processpuzzle.application.configuration.domain.ConfigurationSetUpException;
import com.processpuzzle.application.configuration.domain.InternalizationContext;
import com.processpuzzle.application.configuration.domain.ProcessPuzzleContext;
import com.processpuzzle.application.domain.Application;
import com.processpuzzle.application.security.domain.UserRepository;
import com.processpuzzle.artifact.domain.ArtifactSubClassRepository;
import com.processpuzzle.artifact.domain.DefaultArtifactRepository;
import com.processpuzzle.artifact_type.domain.ArtifactTypeRepository;
import com.processpuzzle.artifact_type_group.domain.ArtifactTypeGroupRepository;
import com.processpuzzle.party.domain.PartyRepository;
import com.processpuzzle.party.partyrelationshiptype.domain.PartyRelationshipTypeRepository;
import com.processpuzzle.party.partyrelationshiptype.domain.PartyRoleTypeRepository;
import com.processpuzzle.resource.resourcetype.domain.ResourceTypeRepository;
import com.processpuzzle.workflow.activity.domain.WorkflowRepository;
import com.processpuzzle.workflow.protocol.domain.ProtocolRepository;

public class DomainTier_ConfigurationFixture {
   protected static ProcessPuzzleContext config = null;
   protected static WorkflowRepository actionRepository;
   protected static DefaultArtifactRepository artifactRepository;
   protected static ArtifactSubClassRepository artifactSubClassRepository;
   protected static ArtifactTypeRepository artifactTypeRepository;
   protected static ArtifactTypeGroupRepository artifactTypeGroupRepository;
   protected static CountryRepository countryRepository;
   protected static InternalizationContext internalizationRepository = null;
   protected static PartyRelationshipTypeRepository partyRelationshipTypeRepository;
   protected static PartyRepository partyRepository;
   protected static PartyRoleTypeRepository partyRoleTypeRepository;
   protected static ProtocolRepository protocolRepository;
   protected static ResourceTypeRepository resourceTypeRepository;
   protected static SettlementRepository settlementRepository;
   protected static UserRepository userRepository = null;
   protected static ZipCodeRepository zipCodeRepository;
   protected static DomainTier_ConfigurationFixture fixtureInstance = null;
   @Mock private Application application;

   public static DomainTier_ConfigurationFixture getInstance() {
      if( fixtureInstance == null ){
         return new DomainTier_ConfigurationFixture();
      }
      return fixtureInstance;
   }

   public void setUp() {
      MockitoAnnotations.initMocks( DomainTier_ConfigurationFixture.class );
      config = ApplicationContextFactory.create( application, DomainTierTestConfiguration.APPLICATION_CONFIGURATION_DESCRIPTOR_PATH );
      try{
         config.setUp( Application.Action.start );
         getDomainTierRepositories();
      }catch( ConfigurationSetUpException e ){
         e.printStackTrace();
      }
   }

   public void tearDown() {
      config.tearDown( Application.Action.stop );
      config = null;
      internalizationRepository = null;
      userRepository = null;
      fixtureInstance = null;
   }

   public static WorkflowRepository getActionRepository() {
      return actionRepository;
   }

   public static DefaultArtifactRepository getArtifactRepository() {
      return artifactRepository;
   }

   public static ArtifactSubClassRepository getArtifactSubClassRepository() {
      return artifactSubClassRepository;
   }

   public static ArtifactTypeGroupRepository getArtifactTypeGroupRepository() {
      return artifactTypeGroupRepository;
   }

   public static ArtifactTypeRepository getArtifactTypeRepository() {
      return artifactTypeRepository;
   }

   public static ProcessPuzzleContext getConfig() {
      return config;
   }

   public static CountryRepository getCountryRepository() {
      return countryRepository;
   }

   public static InternalizationContext getInternalizationRepository() {
      return internalizationRepository;
   }

   public static PartyRelationshipTypeRepository getPartyRelationshipTypeRepository() {
      return partyRelationshipTypeRepository;
   }

   public static PartyRepository getPartyRepository() { return partyRepository; }

   public static PartyRoleTypeRepository getPartyRoleTypeRepository() {
      return partyRoleTypeRepository;
   }

   public static ProtocolRepository getProtocolRepository() {
      return protocolRepository;
   }

   public static ResourceTypeRepository getResourceTypeRepository() {
      return resourceTypeRepository;
   }

   public static SettlementRepository getSettlementRepository() {
      return settlementRepository;
   }

   public static UserRepository getUserRepository() {
      return userRepository;
   }

   public static ZipCodeRepository getZipCodeRepository() {
      return zipCodeRepository;
   }

   protected void getDomainTierRepositories() {
      internalizationRepository = config.getInternalizationContext();
      userRepository = (UserRepository) config.getRepository( UserRepository.class );
   }
}
