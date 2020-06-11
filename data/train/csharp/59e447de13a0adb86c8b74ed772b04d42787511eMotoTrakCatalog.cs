using System;
using System.Collections.Generic;
using Codefire.Storm;
using MotoTrak.Entities;

namespace MotoTrak.DataLogic
{
    public class MotoTrakCatalog : StormContext
    {
        public MotoTrakCatalog()
            : base("MotoTrak")
        {
        }

        public AttachmentRepository Attachments
        {
            get { return GetRepository<AttachmentRepository>(); }
        }

        public ClaimHistoryRepository ClaimHistory
        {
            get { return GetRepository<ClaimHistoryRepository>(); }
        }

        public ClaimLabourRepository ClaimLabour
        {
            get { return GetRepository<ClaimLabourRepository>(); }
        }

        public ClaimMiscellaneousRepository ClaimMiscellaneous
        {
            get { return GetRepository<ClaimMiscellaneousRepository>(); }
        }

        public ClaimPartRepository ClaimParts
        {
            get { return GetRepository<ClaimPartRepository>(); }
        }

        public ClaimQueueRepository ClaimQueues
        {
            get { return GetRepository<ClaimQueueRepository>(); }
        }

        public ClaimRepository Claims
        {
            get { return GetRepository<ClaimRepository>(); }
        }

        public ClaimStatusRepository ClaimStatuses
        {
            get { return GetRepository<ClaimStatusRepository>(); }
        }

        public ClaimTypeRepository ClaimTypes
        {
            get { return GetRepository<ClaimTypeRepository>(); }
        }

        public ConditionRepository Conditions
        {
            get { return GetRepository<ConditionRepository>(); }
        }

        public CustomerRepository Customers
        {
            get { return GetRepository<CustomerRepository>(); }
        }

        public CustomerConcernRepository CustomerConcerns
        {
            get { return GetRepository<CustomerConcernRepository>(); }
        }

        public DealerRepository Dealers
        {
            get { return GetRepository<DealerRepository>(); }
        }


        public GenderRepository Genders
        {
            get { return GetRepository<GenderRepository>(); }
        }

        public LabourRepository Labour
        {
            get { return GetRepository<LabourRepository>(); }
        }

        public LanguageRepository Languages
        {
            get { return GetRepository<LanguageRepository>(); }
        }

        public MiscellaneousRepository Miscellaneous
        {
            get { return GetRepository<MiscellaneousRepository>(); }
        }

        public ModelRepository Models
        {
            get { return GetRepository<ModelRepository>(); }
        }

        public PartRepository Parts
        {
            get { return GetRepository<PartRepository>(); }
        }

        public PartDiscountRepository PartDiscounts
        {
            get { return GetRepository<PartDiscountRepository>(); }
        }

        public PartPriceRepository PartPrices
        {
            get { return GetRepository<PartPriceRepository>(); }
        }

        public PartTypeRepository PartTypes
        {
            get { return GetRepository<PartTypeRepository>(); }
        }

        public ProductRepository Products
        {
            get { return GetRepository<ProductRepository>(); }
        }

        public ProgramRepository Programs
        {
            get { return GetRepository<ProgramRepository>(); }
        }

        public PolicyRepository Policies
        {
            get { return GetRepository<PolicyRepository>(); }
        }

        public PolicyStatusRepository PolicyStatuses
        {
            get { return GetRepository<PolicyStatusRepository>(); }
        }

        public RejectionReasonRepository RejectionReasons
        {
            get { return GetRepository<RejectionReasonRepository>(); }
        }

        public UserRepository Users
        {
            get { return GetRepository<UserRepository>(); }
        }

        public VehicleNoteRepository VehicleNotes
        {
            get { return GetRepository<VehicleNoteRepository>(); }
        }

        public VehicleRepository Vehicles
        {
            get { return GetRepository<VehicleRepository>(); }
        }

        public VehicleServiceRepository VehicleServices
        {
            get { return GetRepository<VehicleServiceRepository>(); }
        }

        public VehicleStatusRepository VehicleStatuses
        {
            get { return GetRepository<VehicleStatusRepository>(); }
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.Strategy = new MotoTrakStrategy();
            builder.AddAssemblyOf<MotoTrakCatalog>();
            builder.UseOverridesFromAssemblyOf<MotoTrakCatalog>();
        }
    }
}