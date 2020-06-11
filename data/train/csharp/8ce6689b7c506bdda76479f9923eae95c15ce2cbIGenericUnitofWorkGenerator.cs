using System;
using System.Data.Entity;
using RentalMobile.Model.Models;
using RentalMobile.Model.ModelViews;
using RentalModel.Repository.Generic.Repositories.Base;

namespace RentalModel.Repository.Generic.UnitofWork
{
    public partial class UnitofWork : IGenericUnitofWork
    {
        public  DbContext Context;

        public UnitofWork()
        {
            Context = new RentalContext();
        }

        public UnitofWork(DbContext context)
        {
            Context = context;
        }

        //Model
 

        private IGenericRepository<Agent> _agentRepository;
        public IGenericRepository<Agent> AgentRepository
        {
            get { return  _agentRepository ?? ( _agentRepository = new GenericRepository<Agent>(Context)); }
            set {  _agentRepository = value; }
        }
    

        private IGenericRepository<AgentAcceptedApplication> _agentAcceptedApplicationRepository;
        public IGenericRepository<AgentAcceptedApplication> AgentAcceptedApplicationRepository
        {
            get { return  _agentAcceptedApplicationRepository ?? ( _agentAcceptedApplicationRepository = new GenericRepository<AgentAcceptedApplication>(Context)); }
            set {  _agentAcceptedApplicationRepository = value; }
        }
    

        private IGenericRepository<AgentAcceptedPostedProject> _agentAcceptedPostedProjectRepository;
        public IGenericRepository<AgentAcceptedPostedProject> AgentAcceptedPostedProjectRepository
        {
            get { return  _agentAcceptedPostedProjectRepository ?? ( _agentAcceptedPostedProjectRepository = new GenericRepository<AgentAcceptedPostedProject>(Context)); }
            set {  _agentAcceptedPostedProjectRepository = value; }
        }
    

        private IGenericRepository<AgentPendingApplication> _agentPendingApplicationRepository;
        public IGenericRepository<AgentPendingApplication> AgentPendingApplicationRepository
        {
            get { return  _agentPendingApplicationRepository ?? ( _agentPendingApplicationRepository = new GenericRepository<AgentPendingApplication>(Context)); }
            set {  _agentPendingApplicationRepository = value; }
        }
    

        private IGenericRepository<AgentPendingPostedProject> _agentPendingPostedProjectRepository;
        public IGenericRepository<AgentPendingPostedProject> AgentPendingPostedProjectRepository
        {
            get { return  _agentPendingPostedProjectRepository ?? ( _agentPendingPostedProjectRepository = new GenericRepository<AgentPendingPostedProject>(Context)); }
            set {  _agentPendingPostedProjectRepository = value; }
        }
    

        private IGenericRepository<AgentProject> _agentProjectRepository;
        public IGenericRepository<AgentProject> AgentProjectRepository
        {
            get { return  _agentProjectRepository ?? ( _agentProjectRepository = new GenericRepository<AgentProject>(Context)); }
            set {  _agentProjectRepository = value; }
        }
    

        private IGenericRepository<AgentRejectedApplication> _agentRejectedApplicationRepository;
        public IGenericRepository<AgentRejectedApplication> AgentRejectedApplicationRepository
        {
            get { return  _agentRejectedApplicationRepository ?? ( _agentRejectedApplicationRepository = new GenericRepository<AgentRejectedApplication>(Context)); }
            set {  _agentRejectedApplicationRepository = value; }
        }
    

        private IGenericRepository<AgentRejectedPostedProject> _agentRejectedPostedProjectRepository;
        public IGenericRepository<AgentRejectedPostedProject> AgentRejectedPostedProjectRepository
        {
            get { return  _agentRejectedPostedProjectRepository ?? ( _agentRejectedPostedProjectRepository = new GenericRepository<AgentRejectedPostedProject>(Context)); }
            set {  _agentRejectedPostedProjectRepository = value; }
        }
    

        private IGenericRepository<aspnet_Applications> _aspnetApplicationsRepository;
        public IGenericRepository<aspnet_Applications> AspnetApplicationsRepository
        {
            get { return  _aspnetApplicationsRepository ?? ( _aspnetApplicationsRepository = new GenericRepository<aspnet_Applications>(Context)); }
            set {  _aspnetApplicationsRepository = value; }
        }
    

        private IGenericRepository<aspnet_Membership> _aspnetMembershipRepository;
        public IGenericRepository<aspnet_Membership> AspnetMembershipRepository
        {
            get { return  _aspnetMembershipRepository ?? ( _aspnetMembershipRepository = new GenericRepository<aspnet_Membership>(Context)); }
            set {  _aspnetMembershipRepository = value; }
        }
    

        private IGenericRepository<aspnet_Paths> _aspnetPathsRepository;
        public IGenericRepository<aspnet_Paths> AspnetPathsRepository
        {
            get { return  _aspnetPathsRepository ?? ( _aspnetPathsRepository = new GenericRepository<aspnet_Paths>(Context)); }
            set {  _aspnetPathsRepository = value; }
        }
    

        private IGenericRepository<aspnet_PersonalizationAllUsers> _aspnetPersonalizationAllUsersRepository;
        public IGenericRepository<aspnet_PersonalizationAllUsers> AspnetPersonalizationAllUsersRepository
        {
            get { return  _aspnetPersonalizationAllUsersRepository ?? ( _aspnetPersonalizationAllUsersRepository = new GenericRepository<aspnet_PersonalizationAllUsers>(Context)); }
            set {  _aspnetPersonalizationAllUsersRepository = value; }
        }
    

        private IGenericRepository<aspnet_PersonalizationPerUser> _aspnetPersonalizationPerUserRepository;
        public IGenericRepository<aspnet_PersonalizationPerUser> AspnetPersonalizationPerUserRepository
        {
            get { return  _aspnetPersonalizationPerUserRepository ?? ( _aspnetPersonalizationPerUserRepository = new GenericRepository<aspnet_PersonalizationPerUser>(Context)); }
            set {  _aspnetPersonalizationPerUserRepository = value; }
        }
    

        private IGenericRepository<aspnet_Profile> _aspnetProfileRepository;
        public IGenericRepository<aspnet_Profile> AspnetProfileRepository
        {
            get { return  _aspnetProfileRepository ?? ( _aspnetProfileRepository = new GenericRepository<aspnet_Profile>(Context)); }
            set {  _aspnetProfileRepository = value; }
        }
    

        private IGenericRepository<aspnet_Roles> _aspnetRolesRepository;
        public IGenericRepository<aspnet_Roles> AspnetRolesRepository
        {
            get { return  _aspnetRolesRepository ?? ( _aspnetRolesRepository = new GenericRepository<aspnet_Roles>(Context)); }
            set {  _aspnetRolesRepository = value; }
        }
    

        private IGenericRepository<aspnet_SchemaVersions> _aspnetSchemaVersionsRepository;
        public IGenericRepository<aspnet_SchemaVersions> AspnetSchemaVersionsRepository
        {
            get { return  _aspnetSchemaVersionsRepository ?? ( _aspnetSchemaVersionsRepository = new GenericRepository<aspnet_SchemaVersions>(Context)); }
            set {  _aspnetSchemaVersionsRepository = value; }
        }
    

        private IGenericRepository<aspnet_Users> _aspnetUsersRepository;
        public IGenericRepository<aspnet_Users> AspnetUsersRepository
        {
            get { return  _aspnetUsersRepository ?? ( _aspnetUsersRepository = new GenericRepository<aspnet_Users>(Context)); }
            set {  _aspnetUsersRepository = value; }
        }
    

        private IGenericRepository<aspnet_WebEvent_Events> _aspnetWebEventEventsRepository;
        public IGenericRepository<aspnet_WebEvent_Events> AspnetWebEventEventsRepository
        {
            get { return  _aspnetWebEventEventsRepository ?? ( _aspnetWebEventEventsRepository = new GenericRepository<aspnet_WebEvent_Events>(Context)); }
            set {  _aspnetWebEventEventsRepository = value; }
        }
    

        private IGenericRepository<Basement> _basementRepository;
        public IGenericRepository<Basement> BasementRepository
        {
            get { return  _basementRepository ?? ( _basementRepository = new GenericRepository<Basement>(Context)); }
            set {  _basementRepository = value; }
        }
    

        private IGenericRepository<Bathroom> _bathroomRepository;
        public IGenericRepository<Bathroom> BathroomRepository
        {
            get { return  _bathroomRepository ?? ( _bathroomRepository = new GenericRepository<Bathroom>(Context)); }
            set {  _bathroomRepository = value; }
        }
    

        private IGenericRepository<Bed> _bedRepository;
        public IGenericRepository<Bed> BedRepository
        {
            get { return  _bedRepository ?? ( _bedRepository = new GenericRepository<Bed>(Context)); }
            set {  _bedRepository = value; }
        }
    

        private IGenericRepository<Cooling> _coolingRepository;
        public IGenericRepository<Cooling> CoolingRepository
        {
            get { return  _coolingRepository ?? ( _coolingRepository = new GenericRepository<Cooling>(Context)); }
            set {  _coolingRepository = value; }
        }
    

        private IGenericRepository<Currency> _currencyRepository;
        public IGenericRepository<Currency> CurrencyRepository
        {
            get { return  _currencyRepository ?? ( _currencyRepository = new GenericRepository<Currency>(Context)); }
            set {  _currencyRepository = value; }
        }
    

        private IGenericRepository<Floor> _floorRepository;
        public IGenericRepository<Floor> FloorRepository
        {
            get { return  _floorRepository ?? ( _floorRepository = new GenericRepository<Floor>(Context)); }
            set {  _floorRepository = value; }
        }
    

        private IGenericRepository<FloorCovering> _floorCoveringRepository;
        public IGenericRepository<FloorCovering> FloorCoveringRepository
        {
            get { return  _floorCoveringRepository ?? ( _floorCoveringRepository = new GenericRepository<FloorCovering>(Context)); }
            set {  _floorCoveringRepository = value; }
        }
    

        private IGenericRepository<Foundation> _foundationRepository;
        public IGenericRepository<Foundation> FoundationRepository
        {
            get { return  _foundationRepository ?? ( _foundationRepository = new GenericRepository<Foundation>(Context)); }
            set {  _foundationRepository = value; }
        }
    

        private IGenericRepository<Garage> _garageRepository;
        public IGenericRepository<Garage> GarageRepository
        {
            get { return  _garageRepository ?? ( _garageRepository = new GenericRepository<Garage>(Context)); }
            set {  _garageRepository = value; }
        }
    

        private IGenericRepository<GeneratedRentalContract> _generatedRentalContractRepository;
        public IGenericRepository<GeneratedRentalContract> GeneratedRentalContractRepository
        {
            get { return  _generatedRentalContractRepository ?? ( _generatedRentalContractRepository = new GenericRepository<GeneratedRentalContract>(Context)); }
            set {  _generatedRentalContractRepository = value; }
        }
    

        private IGenericRepository<Heating> _heatingRepository;
        public IGenericRepository<Heating> HeatingRepository
        {
            get { return  _heatingRepository ?? ( _heatingRepository = new GenericRepository<Heating>(Context)); }
            set {  _heatingRepository = value; }
        }
    

        private IGenericRepository<MaintenanceCompany> _maintenanceCompanyRepository;
        public IGenericRepository<MaintenanceCompany> MaintenanceCompanyRepository
        {
            get { return  _maintenanceCompanyRepository ?? ( _maintenanceCompanyRepository = new GenericRepository<MaintenanceCompany>(Context)); }
            set {  _maintenanceCompanyRepository = value; }
        }
    

        private IGenericRepository<MaintenanceCompanyLookUp> _maintenanceCompanyLookUpRepository;
        public IGenericRepository<MaintenanceCompanyLookUp> MaintenanceCompanyLookUpRepository
        {
            get { return  _maintenanceCompanyLookUpRepository ?? ( _maintenanceCompanyLookUpRepository = new GenericRepository<MaintenanceCompanyLookUp>(Context)); }
            set {  _maintenanceCompanyLookUpRepository = value; }
        }
    

        private IGenericRepository<MaintenanceCompanySpecialization> _maintenanceCompanySpecializationRepository;
        public IGenericRepository<MaintenanceCompanySpecialization> MaintenanceCompanySpecializationRepository
        {
            get { return  _maintenanceCompanySpecializationRepository ?? ( _maintenanceCompanySpecializationRepository = new GenericRepository<MaintenanceCompanySpecialization>(Context)); }
            set {  _maintenanceCompanySpecializationRepository = value; }
        }
    

        private IGenericRepository<MaintenanceCrew> _maintenanceCrewRepository;
        public IGenericRepository<MaintenanceCrew> MaintenanceCrewRepository
        {
            get { return  _maintenanceCrewRepository ?? ( _maintenanceCrewRepository = new GenericRepository<MaintenanceCrew>(Context)); }
            set {  _maintenanceCrewRepository = value; }
        }
    

        private IGenericRepository<MaintenanceCustomService> _maintenanceCustomServiceRepository;
        public IGenericRepository<MaintenanceCustomService> MaintenanceCustomServiceRepository
        {
            get { return  _maintenanceCustomServiceRepository ?? ( _maintenanceCustomServiceRepository = new GenericRepository<MaintenanceCustomService>(Context)); }
            set {  _maintenanceCustomServiceRepository = value; }
        }
    

        private IGenericRepository<MaintenanceExterior> _maintenanceExteriorRepository;
        public IGenericRepository<MaintenanceExterior> MaintenanceExteriorRepository
        {
            get { return  _maintenanceExteriorRepository ?? ( _maintenanceExteriorRepository = new GenericRepository<MaintenanceExterior>(Context)); }
            set {  _maintenanceExteriorRepository = value; }
        }
    

        private IGenericRepository<MaintenanceInterior> _maintenanceInteriorRepository;
        public IGenericRepository<MaintenanceInterior> MaintenanceInteriorRepository
        {
            get { return  _maintenanceInteriorRepository ?? ( _maintenanceInteriorRepository = new GenericRepository<MaintenanceInterior>(Context)); }
            set {  _maintenanceInteriorRepository = value; }
        }
    

        private IGenericRepository<MaintenanceNewConstruction> _maintenanceNewConstructionRepository;
        public IGenericRepository<MaintenanceNewConstruction> MaintenanceNewConstructionRepository
        {
            get { return  _maintenanceNewConstructionRepository ?? ( _maintenanceNewConstructionRepository = new GenericRepository<MaintenanceNewConstruction>(Context)); }
            set {  _maintenanceNewConstructionRepository = value; }
        }
    

        private IGenericRepository<MaintenanceOrder> _maintenanceOrderRepository;
        public IGenericRepository<MaintenanceOrder> MaintenanceOrderRepository
        {
            get { return  _maintenanceOrderRepository ?? ( _maintenanceOrderRepository = new GenericRepository<MaintenanceOrder>(Context)); }
            set {  _maintenanceOrderRepository = value; }
        }
    

        private IGenericRepository<MaintenancePhoto> _maintenancePhotoRepository;
        public IGenericRepository<MaintenancePhoto> MaintenancePhotoRepository
        {
            get { return  _maintenancePhotoRepository ?? ( _maintenancePhotoRepository = new GenericRepository<MaintenancePhoto>(Context)); }
            set {  _maintenancePhotoRepository = value; }
        }
    

        private IGenericRepository<MaintenanceProvider> _maintenanceProviderRepository;
        public IGenericRepository<MaintenanceProvider> MaintenanceProviderRepository
        {
            get { return  _maintenanceProviderRepository ?? ( _maintenanceProviderRepository = new GenericRepository<MaintenanceProvider>(Context)); }
            set {  _maintenanceProviderRepository = value; }
        }
    

        private IGenericRepository<MaintenanceProviderAcceptedJob> _maintenanceProviderAcceptedJobRepository;
        public IGenericRepository<MaintenanceProviderAcceptedJob> MaintenanceProviderAcceptedJobRepository
        {
            get { return  _maintenanceProviderAcceptedJobRepository ?? ( _maintenanceProviderAcceptedJobRepository = new GenericRepository<MaintenanceProviderAcceptedJob>(Context)); }
            set {  _maintenanceProviderAcceptedJobRepository = value; }
        }
    

        private IGenericRepository<MaintenanceProviderNewJobOffer> _maintenanceProviderNewJobOfferRepository;
        public IGenericRepository<MaintenanceProviderNewJobOffer> MaintenanceProviderNewJobOfferRepository
        {
            get { return  _maintenanceProviderNewJobOfferRepository ?? ( _maintenanceProviderNewJobOfferRepository = new GenericRepository<MaintenanceProviderNewJobOffer>(Context)); }
            set {  _maintenanceProviderNewJobOfferRepository = value; }
        }
    

        private IGenericRepository<MaintenanceProviderRejectedJob> _maintenanceProviderRejectedJobRepository;
        public IGenericRepository<MaintenanceProviderRejectedJob> MaintenanceProviderRejectedJobRepository
        {
            get { return  _maintenanceProviderRejectedJobRepository ?? ( _maintenanceProviderRejectedJobRepository = new GenericRepository<MaintenanceProviderRejectedJob>(Context)); }
            set {  _maintenanceProviderRejectedJobRepository = value; }
        }
    

        private IGenericRepository<MaintenanceProviderZone> _maintenanceProviderZoneRepository;
        public IGenericRepository<MaintenanceProviderZone> MaintenanceProviderZoneRepository
        {
            get { return  _maintenanceProviderZoneRepository ?? ( _maintenanceProviderZoneRepository = new GenericRepository<MaintenanceProviderZone>(Context)); }
            set {  _maintenanceProviderZoneRepository = value; }
        }
    

        private IGenericRepository<MaintenanceRepair> _maintenanceRepairRepository;
        public IGenericRepository<MaintenanceRepair> MaintenanceRepairRepository
        {
            get { return  _maintenanceRepairRepository ?? ( _maintenanceRepairRepository = new GenericRepository<MaintenanceRepair>(Context)); }
            set {  _maintenanceRepairRepository = value; }
        }
    

        private IGenericRepository<MaintenanceTeam> _maintenanceTeamRepository;
        public IGenericRepository<MaintenanceTeam> MaintenanceTeamRepository
        {
            get { return  _maintenanceTeamRepository ?? ( _maintenanceTeamRepository = new GenericRepository<MaintenanceTeam>(Context)); }
            set {  _maintenanceTeamRepository = value; }
        }
    

        private IGenericRepository<MaintenanceTeamAssociation> _maintenanceTeamAssociationRepository;
        public IGenericRepository<MaintenanceTeamAssociation> MaintenanceTeamAssociationRepository
        {
            get { return  _maintenanceTeamAssociationRepository ?? ( _maintenanceTeamAssociationRepository = new GenericRepository<MaintenanceTeamAssociation>(Context)); }
            set {  _maintenanceTeamAssociationRepository = value; }
        }
    

        private IGenericRepository<MaintenanceUtility> _maintenanceUtilityRepository;
        public IGenericRepository<MaintenanceUtility> MaintenanceUtilityRepository
        {
            get { return  _maintenanceUtilityRepository ?? ( _maintenanceUtilityRepository = new GenericRepository<MaintenanceUtility>(Context)); }
            set {  _maintenanceUtilityRepository = value; }
        }
    

        private IGenericRepository<Owner> _ownerRepository;
        public IGenericRepository<Owner> OwnerRepository
        {
            get { return  _ownerRepository ?? ( _ownerRepository = new GenericRepository<Owner>(Context)); }
            set {  _ownerRepository = value; }
        }
    

        private IGenericRepository<OwnerAcceptedApplication> _ownerAcceptedApplicationRepository;
        public IGenericRepository<OwnerAcceptedApplication> OwnerAcceptedApplicationRepository
        {
            get { return  _ownerAcceptedApplicationRepository ?? ( _ownerAcceptedApplicationRepository = new GenericRepository<OwnerAcceptedApplication>(Context)); }
            set {  _ownerAcceptedApplicationRepository = value; }
        }
    

        private IGenericRepository<OwnerAcceptedPostedProject> _ownerAcceptedPostedProjectRepository;
        public IGenericRepository<OwnerAcceptedPostedProject> OwnerAcceptedPostedProjectRepository
        {
            get { return  _ownerAcceptedPostedProjectRepository ?? ( _ownerAcceptedPostedProjectRepository = new GenericRepository<OwnerAcceptedPostedProject>(Context)); }
            set {  _ownerAcceptedPostedProjectRepository = value; }
        }
    

        private IGenericRepository<OwnerMaintenance> _ownerMaintenanceRepository;
        public IGenericRepository<OwnerMaintenance> OwnerMaintenanceRepository
        {
            get { return  _ownerMaintenanceRepository ?? ( _ownerMaintenanceRepository = new GenericRepository<OwnerMaintenance>(Context)); }
            set {  _ownerMaintenanceRepository = value; }
        }
    

        private IGenericRepository<OwnerPendingApplication> _ownerPendingApplicationRepository;
        public IGenericRepository<OwnerPendingApplication> OwnerPendingApplicationRepository
        {
            get { return  _ownerPendingApplicationRepository ?? ( _ownerPendingApplicationRepository = new GenericRepository<OwnerPendingApplication>(Context)); }
            set {  _ownerPendingApplicationRepository = value; }
        }
    

        private IGenericRepository<OwnerPendingPostedProject> _ownerPendingPostedProjectRepository;
        public IGenericRepository<OwnerPendingPostedProject> OwnerPendingPostedProjectRepository
        {
            get { return  _ownerPendingPostedProjectRepository ?? ( _ownerPendingPostedProjectRepository = new GenericRepository<OwnerPendingPostedProject>(Context)); }
            set {  _ownerPendingPostedProjectRepository = value; }
        }
    

        private IGenericRepository<OwnerPendingShowingCalendar> _ownerPendingShowingCalendarRepository;
        public IGenericRepository<OwnerPendingShowingCalendar> OwnerPendingShowingCalendarRepository
        {
            get { return  _ownerPendingShowingCalendarRepository ?? ( _ownerPendingShowingCalendarRepository = new GenericRepository<OwnerPendingShowingCalendar>(Context)); }
            set {  _ownerPendingShowingCalendarRepository = value; }
        }
    

        private IGenericRepository<OwnerProject> _ownerProjectRepository;
        public IGenericRepository<OwnerProject> OwnerProjectRepository
        {
            get { return  _ownerProjectRepository ?? ( _ownerProjectRepository = new GenericRepository<OwnerProject>(Context)); }
            set {  _ownerProjectRepository = value; }
        }
    

        private IGenericRepository<OwnerRejectedApplication> _ownerRejectedApplicationRepository;
        public IGenericRepository<OwnerRejectedApplication> OwnerRejectedApplicationRepository
        {
            get { return  _ownerRejectedApplicationRepository ?? ( _ownerRejectedApplicationRepository = new GenericRepository<OwnerRejectedApplication>(Context)); }
            set {  _ownerRejectedApplicationRepository = value; }
        }
    

        private IGenericRepository<OwnerRejectedPostedProject> _ownerRejectedPostedProjectRepository;
        public IGenericRepository<OwnerRejectedPostedProject> OwnerRejectedPostedProjectRepository
        {
            get { return  _ownerRejectedPostedProjectRepository ?? ( _ownerRejectedPostedProjectRepository = new GenericRepository<OwnerRejectedPostedProject>(Context)); }
            set {  _ownerRejectedPostedProjectRepository = value; }
        }
    

        private IGenericRepository<OwnerShowingCalendar> _ownerShowingCalendarRepository;
        public IGenericRepository<OwnerShowingCalendar> OwnerShowingCalendarRepository
        {
            get { return  _ownerShowingCalendarRepository ?? ( _ownerShowingCalendarRepository = new GenericRepository<OwnerShowingCalendar>(Context)); }
            set {  _ownerShowingCalendarRepository = value; }
        }
    

        private IGenericRepository<ParkingSpace> _parkingSpaceRepository;
        public IGenericRepository<ParkingSpace> ParkingSpaceRepository
        {
            get { return  _parkingSpaceRepository ?? ( _parkingSpaceRepository = new GenericRepository<ParkingSpace>(Context)); }
            set {  _parkingSpaceRepository = value; }
        }
    

        private IGenericRepository<Project> _projectRepository;
        public IGenericRepository<Project> ProjectRepository
        {
            get { return  _projectRepository ?? ( _projectRepository = new GenericRepository<Project>(Context)); }
            set {  _projectRepository = value; }
        }
    

        private IGenericRepository<ProjectPhoto> _projectPhotoRepository;
        public IGenericRepository<ProjectPhoto> ProjectPhotoRepository
        {
            get { return  _projectPhotoRepository ?? ( _projectPhotoRepository = new GenericRepository<ProjectPhoto>(Context)); }
            set {  _projectPhotoRepository = value; }
        }
    

        private IGenericRepository<ProviderProfileComment> _providerProfileCommentRepository;
        public IGenericRepository<ProviderProfileComment> ProviderProfileCommentRepository
        {
            get { return  _providerProfileCommentRepository ?? ( _providerProfileCommentRepository = new GenericRepository<ProviderProfileComment>(Context)); }
            set {  _providerProfileCommentRepository = value; }
        }
    

        private IGenericRepository<ProviderWork> _providerWorkRepository;
        public IGenericRepository<ProviderWork> ProviderWorkRepository
        {
            get { return  _providerWorkRepository ?? ( _providerWorkRepository = new GenericRepository<ProviderWork>(Context)); }
            set {  _providerWorkRepository = value; }
        }
    

        private IGenericRepository<RentalApplication> _rentalApplicationRepository;
        public IGenericRepository<RentalApplication> RentalApplicationRepository
        {
            get { return  _rentalApplicationRepository ?? ( _rentalApplicationRepository = new GenericRepository<RentalApplication>(Context)); }
            set {  _rentalApplicationRepository = value; }
        }
    

        private IGenericRepository<ServiceType> _serviceTypeRepository;
        public IGenericRepository<ServiceType> ServiceTypeRepository
        {
            get { return  _serviceTypeRepository ?? ( _serviceTypeRepository = new GenericRepository<ServiceType>(Context)); }
            set {  _serviceTypeRepository = value; }
        }
    

        private IGenericRepository<Specialist> _specialistRepository;
        public IGenericRepository<Specialist> SpecialistRepository
        {
            get { return  _specialistRepository ?? ( _specialistRepository = new GenericRepository<Specialist>(Context)); }
            set {  _specialistRepository = value; }
        }
    

        private IGenericRepository<SpecialistPendingTeamInvitation> _specialistPendingTeamInvitationRepository;
        public IGenericRepository<SpecialistPendingTeamInvitation> SpecialistPendingTeamInvitationRepository
        {
            get { return  _specialistPendingTeamInvitationRepository ?? ( _specialistPendingTeamInvitationRepository = new GenericRepository<SpecialistPendingTeamInvitation>(Context)); }
            set {  _specialistPendingTeamInvitationRepository = value; }
        }
    

        private IGenericRepository<SpecialistProfileComment> _specialistProfileCommentRepository;
        public IGenericRepository<SpecialistProfileComment> SpecialistProfileCommentRepository
        {
            get { return  _specialistProfileCommentRepository ?? ( _specialistProfileCommentRepository = new GenericRepository<SpecialistProfileComment>(Context)); }
            set {  _specialistProfileCommentRepository = value; }
        }
    

        private IGenericRepository<SpecialistWork> _specialistWorkRepository;
        public IGenericRepository<SpecialistWork> SpecialistWorkRepository
        {
            get { return  _specialistWorkRepository ?? ( _specialistWorkRepository = new GenericRepository<SpecialistWork>(Context)); }
            set {  _specialistWorkRepository = value; }
        }
    

        private IGenericRepository<Tenant> _tenantRepository;
        public IGenericRepository<Tenant> TenantRepository
        {
            get { return  _tenantRepository ?? ( _tenantRepository = new GenericRepository<Tenant>(Context)); }
            set {  _tenantRepository = value; }
        }
    

        private IGenericRepository<TenantFavorite> _tenantFavoriteRepository;
        public IGenericRepository<TenantFavorite> TenantFavoriteRepository
        {
            get { return  _tenantFavoriteRepository ?? ( _tenantFavoriteRepository = new GenericRepository<TenantFavorite>(Context)); }
            set {  _tenantFavoriteRepository = value; }
        }
    

        private IGenericRepository<TenantMaintenance> _tenantMaintenanceRepository;
        public IGenericRepository<TenantMaintenance> TenantMaintenanceRepository
        {
            get { return  _tenantMaintenanceRepository ?? ( _tenantMaintenanceRepository = new GenericRepository<TenantMaintenance>(Context)); }
            set {  _tenantMaintenanceRepository = value; }
        }
    

        private IGenericRepository<TenantSavedSearch> _tenantSavedSearchRepository;
        public IGenericRepository<TenantSavedSearch> TenantSavedSearchRepository
        {
            get { return  _tenantSavedSearchRepository ?? ( _tenantSavedSearchRepository = new GenericRepository<TenantSavedSearch>(Context)); }
            set {  _tenantSavedSearchRepository = value; }
        }
    

        private IGenericRepository<TenantShowing> _tenantShowingRepository;
        public IGenericRepository<TenantShowing> TenantShowingRepository
        {
            get { return  _tenantShowingRepository ?? ( _tenantShowingRepository = new GenericRepository<TenantShowing>(Context)); }
            set {  _tenantShowingRepository = value; }
        }
    

        private IGenericRepository<Unit> _unitRepository;
        public IGenericRepository<Unit> UnitRepository
        {
            get { return  _unitRepository ?? ( _unitRepository = new GenericRepository<Unit>(Context)); }
            set {  _unitRepository = value; }
        }
    

        private IGenericRepository<UnitAppliance> _unitApplianceRepository;
        public IGenericRepository<UnitAppliance> UnitApplianceRepository
        {
            get { return  _unitApplianceRepository ?? ( _unitApplianceRepository = new GenericRepository<UnitAppliance>(Context)); }
            set {  _unitApplianceRepository = value; }
        }
    

        private IGenericRepository<UnitCommunityAmenity> _unitCommunityAmenityRepository;
        public IGenericRepository<UnitCommunityAmenity> UnitCommunityAmenityRepository
        {
            get { return  _unitCommunityAmenityRepository ?? ( _unitCommunityAmenityRepository = new GenericRepository<UnitCommunityAmenity>(Context)); }
            set {  _unitCommunityAmenityRepository = value; }
        }
    

        private IGenericRepository<UnitExteriorAmenity> _unitExteriorAmenityRepository;
        public IGenericRepository<UnitExteriorAmenity> UnitExteriorAmenityRepository
        {
            get { return  _unitExteriorAmenityRepository ?? ( _unitExteriorAmenityRepository = new GenericRepository<UnitExteriorAmenity>(Context)); }
            set {  _unitExteriorAmenityRepository = value; }
        }
    

        private IGenericRepository<UnitFeature> _unitFeatureRepository;
        public IGenericRepository<UnitFeature> UnitFeatureRepository
        {
            get { return  _unitFeatureRepository ?? ( _unitFeatureRepository = new GenericRepository<UnitFeature>(Context)); }
            set {  _unitFeatureRepository = value; }
        }
    

        private IGenericRepository<UnitGallery> _unitGalleryRepository;
        public IGenericRepository<UnitGallery> UnitGalleryRepository
        {
            get { return  _unitGalleryRepository ?? ( _unitGalleryRepository = new GenericRepository<UnitGallery>(Context)); }
            set {  _unitGalleryRepository = value; }
        }
    

        private IGenericRepository<UnitInteriorAmenity> _unitInteriorAmenityRepository;
        public IGenericRepository<UnitInteriorAmenity> UnitInteriorAmenityRepository
        {
            get { return  _unitInteriorAmenityRepository ?? ( _unitInteriorAmenityRepository = new GenericRepository<UnitInteriorAmenity>(Context)); }
            set {  _unitInteriorAmenityRepository = value; }
        }
    

        private IGenericRepository<UnitLuxuryAmenity> _unitLuxuryAmenityRepository;
        public IGenericRepository<UnitLuxuryAmenity> UnitLuxuryAmenityRepository
        {
            get { return  _unitLuxuryAmenityRepository ?? ( _unitLuxuryAmenityRepository = new GenericRepository<UnitLuxuryAmenity>(Context)); }
            set {  _unitLuxuryAmenityRepository = value; }
        }
    

        private IGenericRepository<UnitPricing> _unitPricingRepository;
        public IGenericRepository<UnitPricing> UnitPricingRepository
        {
            get { return  _unitPricingRepository ?? ( _unitPricingRepository = new GenericRepository<UnitPricing>(Context)); }
            set {  _unitPricingRepository = value; }
        }
    

        private IGenericRepository<UnitType> _unitTypeRepository;
        public IGenericRepository<UnitType> UnitTypeRepository
        {
            get { return  _unitTypeRepository ?? ( _unitTypeRepository = new GenericRepository<UnitType>(Context)); }
            set {  _unitTypeRepository = value; }
        }
    

        private IGenericRepository<UploadedContract> _uploadedContractRepository;
        public IGenericRepository<UploadedContract> UploadedContractRepository
        {
            get { return  _uploadedContractRepository ?? ( _uploadedContractRepository = new GenericRepository<UploadedContract>(Context)); }
            set {  _uploadedContractRepository = value; }
        }
    

        private IGenericRepository<UrgencyType> _urgencyTypeRepository;
        public IGenericRepository<UrgencyType> UrgencyTypeRepository
        {
            get { return  _urgencyTypeRepository ?? ( _urgencyTypeRepository = new GenericRepository<UrgencyType>(Context)); }
            set {  _urgencyTypeRepository = value; }
        }
    

        //ModelView


        private IGenericRepository<ChangeEmail> _changeEmailRepository;
        public IGenericRepository<ChangeEmail> ChangeEmailRepository
        {
            get { return  _changeEmailRepository ?? ( _changeEmailRepository = new GenericRepository<ChangeEmail>(Context)); }
            set {  _changeEmailRepository = value; }
        }
    

        private IGenericRepository<ChangePasswordModel> _changePasswordModelRepository;
        public IGenericRepository<ChangePasswordModel> ChangePasswordModelRepository
        {
            get { return  _changePasswordModelRepository ?? ( _changePasswordModelRepository = new GenericRepository<ChangePasswordModel>(Context)); }
            set {  _changePasswordModelRepository = value; }
        }
    

        private IGenericRepository<ForgotPasswordModel> _forgotPasswordModelRepository;
        public IGenericRepository<ForgotPasswordModel> ForgotPasswordModelRepository
        {
            get { return  _forgotPasswordModelRepository ?? ( _forgotPasswordModelRepository = new GenericRepository<ForgotPasswordModel>(Context)); }
            set {  _forgotPasswordModelRepository = value; }
        }
    

        private IGenericRepository<LogOnModel> _logOnModelRepository;
        public IGenericRepository<LogOnModel> LogOnModelRepository
        {
            get { return  _logOnModelRepository ?? ( _logOnModelRepository = new GenericRepository<LogOnModel>(Context)); }
            set {  _logOnModelRepository = value; }
        }
    

        private IGenericRepository<OwnerPendingShowingCalendarModelView> _ownerPendingShowingCalendarModelViewRepository;
        public IGenericRepository<OwnerPendingShowingCalendarModelView> OwnerPendingShowingCalendarModelViewRepository
        {
            get { return  _ownerPendingShowingCalendarModelViewRepository ?? ( _ownerPendingShowingCalendarModelViewRepository = new GenericRepository<OwnerPendingShowingCalendarModelView>(Context)); }
            set {  _ownerPendingShowingCalendarModelViewRepository = value; }
        }
    

        private IGenericRepository<PrimaryVideo> _primaryVideoRepository;
        public IGenericRepository<PrimaryVideo> PrimaryVideoRepository
        {
            get { return  _primaryVideoRepository ?? ( _primaryVideoRepository = new GenericRepository<PrimaryVideo>(Context)); }
            set {  _primaryVideoRepository = value; }
        }
    

        private IGenericRepository<ProviderMaintenanceCompleteProfile> _providerMaintenanceCompleteProfileRepository;
        public IGenericRepository<ProviderMaintenanceCompleteProfile> ProviderMaintenanceCompleteProfileRepository
        {
            get { return  _providerMaintenanceCompleteProfileRepository ?? ( _providerMaintenanceCompleteProfileRepository = new GenericRepository<ProviderMaintenanceCompleteProfile>(Context)); }
            set {  _providerMaintenanceCompleteProfileRepository = value; }
        }
    

        private IGenericRepository<ProviderMaintenanceProfile> _providerMaintenanceProfileRepository;
        public IGenericRepository<ProviderMaintenanceProfile> ProviderMaintenanceProfileRepository
        {
            get { return  _providerMaintenanceProfileRepository ?? ( _providerMaintenanceProfileRepository = new GenericRepository<ProviderMaintenanceProfile>(Context)); }
            set {  _providerMaintenanceProfileRepository = value; }
        }
    

        private IGenericRepository<RegisterModel> _registerModelRepository;
        public IGenericRepository<RegisterModel> RegisterModelRepository
        {
            get { return  _registerModelRepository ?? ( _registerModelRepository = new GenericRepository<RegisterModel>(Context)); }
            set {  _registerModelRepository = value; }
        }
    

        private IGenericRepository<SpecialistMaintenanceProfile> _specialistMaintenanceProfileRepository;
        public IGenericRepository<SpecialistMaintenanceProfile> SpecialistMaintenanceProfileRepository
        {
            get { return  _specialistMaintenanceProfileRepository ?? ( _specialistMaintenanceProfileRepository = new GenericRepository<SpecialistMaintenanceProfile>(Context)); }
            set {  _specialistMaintenanceProfileRepository = value; }
        }
    

        private IGenericRepository<TeamSpecialistInvitation> _teamSpecialistInvitationRepository;
        public IGenericRepository<TeamSpecialistInvitation> TeamSpecialistInvitationRepository
        {
            get { return  _teamSpecialistInvitationRepository ?? ( _teamSpecialistInvitationRepository = new GenericRepository<TeamSpecialistInvitation>(Context)); }
            set {  _teamSpecialistInvitationRepository = value; }
        }
    

        private IGenericRepository<TenantMaintenanceViewModel> _tenantMaintenanceViewModelRepository;
        public IGenericRepository<TenantMaintenanceViewModel> TenantMaintenanceViewModelRepository
        {
            get { return  _tenantMaintenanceViewModelRepository ?? ( _tenantMaintenanceViewModelRepository = new GenericRepository<TenantMaintenanceViewModel>(Context)); }
            set {  _tenantMaintenanceViewModelRepository = value; }
        }
    

        private IGenericRepository<TenantModelView> _tenantModelViewRepository;
        public IGenericRepository<TenantModelView> TenantModelViewRepository
        {
            get { return  _tenantModelViewRepository ?? ( _tenantModelViewRepository = new GenericRepository<TenantModelView>(Context)); }
            set {  _tenantModelViewRepository = value; }
        }
    

        private IGenericRepository<Test> _testRepository;
        public IGenericRepository<Test> TestRepository
        {
            get { return  _testRepository ?? ( _testRepository = new GenericRepository<Test>(Context)); }
            set {  _testRepository = value; }
        }
    

        private IGenericRepository<UnitModelView> _unitModelViewRepository;
        public IGenericRepository<UnitModelView> UnitModelViewRepository
        {
            get { return  _unitModelViewRepository ?? ( _unitModelViewRepository = new GenericRepository<UnitModelView>(Context)); }
            set {  _unitModelViewRepository = value; }
        }
    


        public void Save()
        {
            Context.SaveChanges();
        }

        private bool _disposed;



        public void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    Context.Dispose();
                }
            }
            _disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }     
}




















