package com.processpuzzle.configuration.webtier;

import org.mockito.MockitoAnnotations;
import org.mockito.MockitoAnnotations.Mock;

import com.processpuzzle.address.domain.CountryRepository;
import com.processpuzzle.address.domain.SettlementRepository;
import com.processpuzzle.address.domain.ZipCodeRepository;
import com.processpuzzle.application.configuration.domain.ApplicationContextFactory;
import com.processpuzzle.application.configuration.domain.ConfigurationSetUpException;
import com.processpuzzle.application.configuration.domain.InternalizationContext;
import com.processpuzzle.application.configuration.domain.ProcessPuzzleContext;
import com.processpuzzle.application.domain.Application;
import com.processpuzzle.application.security.domain.UserRepository;
import com.processpuzzle.artifact.domain.ArtifactFolderRepository;
import com.processpuzzle.artifact.domain.DefaultArtifactRepository;
import com.processpuzzle.artifact_type.domain.ArtifactTypeRepository;
import com.processpuzzle.artifact_type_group.domain.ArtifactTypeGroupRepository;
import com.processpuzzle.party.domain.PartyRepository;
import com.processpuzzle.party.partyrelationshiptype.domain.PartyRelationshipTypeRepository;
import com.processpuzzle.party.partyrelationshiptype.domain.PartyRoleTypeRepository;
import com.processpuzzle.resource.resourcetype.domain.ResourceTypeRepository;
import com.processpuzzle.workflow.activity.domain.WorkflowRepository;
import com.processpuzzle.workflow.protocol.domain.ProtocolRepository;

public class ConfigurationFixture {
   private static ProcessPuzzleContext config;
   private static DefaultArtifactRepository artifactRepository;
   private static ArtifactFolderRepository artifactFolderRepository;
   private static ZipCodeRepository zipCodeRepository;
   private static CountryRepository countryRepository;
   private static SettlementRepository settlementRepository;
   private static ResourceTypeRepository resourceTypeRepository;
   private static ArtifactTypeRepository artifactTypeRepository;
   private static ArtifactTypeGroupRepository artifactTypeGroupRepository;
   private static PartyRepository partyRepository;
   private static ProtocolRepository protocolRepository;
   private static WorkflowRepository actionRepository;
   private static PartyRelationshipTypeRepository partyRelationshipTypeRepository;
   private static PartyRoleTypeRepository partyRoleTypeRepository;
   private static InternalizationContext localeRepository;
   private static UserRepository userRepository;
   private static ConfigurationFixture fixtureInstance;
   @Mock
   private Application mockApplication;

   public static ConfigurationFixture getInstance() {
      if( fixtureInstance == null ){
         return new ConfigurationFixture();
      }
      return fixtureInstance;
   }

   public void setUp() {
      MockitoAnnotations.initMocks( ConfigurationFixture.class );
      config = ApplicationContextFactory.create( mockApplication, ConfigurationConstants.CONFIGURATION_PROPERTY_FILE );
      try{
         config.setUp( Application.Action.start );

         artifactRepository = config.getRepository( DefaultArtifactRepository.class );
         artifactFolderRepository = config.getRepository( ArtifactFolderRepository.class );
         zipCodeRepository = config.getRepository( ZipCodeRepository.class );
         countryRepository = config.getRepository( CountryRepository.class );
         settlementRepository = config.getRepository( SettlementRepository.class );
         resourceTypeRepository = config.getRepository( ResourceTypeRepository.class );
         artifactTypeRepository = config.getRepository( ArtifactTypeRepository.class );
         artifactTypeGroupRepository = config.getRepository( ArtifactTypeGroupRepository.class );
         partyRepository = config.getRepository( PartyRepository.class );
         protocolRepository = config.getRepository( ProtocolRepository.class );
         actionRepository = config.getRepository( WorkflowRepository.class );
         partyRelationshipTypeRepository = config.getRepository( PartyRelationshipTypeRepository.class );
         partyRoleTypeRepository = config.getRepository( PartyRoleTypeRepository.class );
         localeRepository = config.getInternalizationContext();
         userRepository = config.getRepository( UserRepository.class );
      }catch( ConfigurationSetUpException e ){
         e.printStackTrace();
      }
   }

   public void tearDown() {
      config = null;
      artifactRepository = null;
      zipCodeRepository = null;
      countryRepository = null;
      settlementRepository = null;
      resourceTypeRepository = null;
      artifactTypeRepository = null;
      artifactTypeGroupRepository = null;
      partyRepository = null;
      protocolRepository = null;
      actionRepository = null;
      partyRelationshipTypeRepository = null;
      partyRoleTypeRepository = null;
      localeRepository = null;
      userRepository = null;
      fixtureInstance = null;
   }

   public static WorkflowRepository getActionRepository() {
      return actionRepository;
   }

   public static DefaultArtifactRepository getArtifactRepository() {
      return artifactRepository;
   }

   public static ArtifactFolderRepository getArtifactFolderRepository() {
      return artifactFolderRepository;
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

   public static InternalizationContext getLocaleRepository() {
      return localeRepository;
   }

   public static PartyRelationshipTypeRepository getPartyRelationshipTypeRepository() {
      return partyRelationshipTypeRepository;
   }

   public static PartyRepository getPartyRepository() {
      return partyRepository;
   }

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

}
