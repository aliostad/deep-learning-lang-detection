using BorgCivil.Framework.Identity;

namespace BorgCivil.Repositories
{
    public interface IUnitOfWork
    {

        AppIdentityDbContext DbEntities { get; }

        AnonymousFieldRepository AnonymousFieldRepository { get; }
        AttachmentsRepository AttachmentsRepository { get; }

        BookingRepository BookingRepository { get; }

        BookingFleetsRepository BookingFleetsRepository { get; }

        BookingSiteGatesRepository BookingSiteGatesRepository { get; }

        BookingSiteSupervisorRepository BookingSiteSupervisorRepository { get; }

        CustomerRepository CustomerRepository { get; }

        CountryRepository CountryRepository { get; }

        DriversRepository DriversRepository { get; }

        DriverWhiteCardRepository DriverWhiteCardRepository { get; }

        DriverInductionCardRepository DriverInductionCardRepository { get; }

        DriverVocCardRepository DriverVocCardRepository { get; }

        DocketRepository DocketRepository { get; }

        DocumentRepository DocumentRepository { get; }

        DocketCheckListRepository DocketCheckListRepository { get; }

        EmployeeRepository EmployeeRepository { get; }

        EmploymentCategoryRepository EmploymentCategoryRepository { get; }

        EmailRepository EmailRepository { get; }

        FleetRepository FleetRepository { get; }

        FleetHistoryRepository FleetHistoryRepository { get; }

        FleetTypesRepository FleetTypesRepository { get; }

        FleetsRegistrationRepository FleetsRegistrationRepository { get; }

        GatesRepository GatesRepository { get; }

        GateContactPersonRepository GateContactPersonRepository { get; }

        LicenseClassRepository LicenseClassRepository { get; }

        LoadDocketRepository LoadDocketRepository { get; }

        SitesRepository SitesRepository { get; }

        SupervisorRepository SupervisorRepository { get; }

        StatusLookupRepository StatusLookupRepository { get; }

        SubcontractorRepository SubcontractorRepository { get; }

        StateRepository StateRepository { get; }

        WorkTypesRepository WorkTypesRepository { get; }

        DemoRepository DemoRepository { get; }

        void Commit();
        void CommitTransaction();
    }
}
