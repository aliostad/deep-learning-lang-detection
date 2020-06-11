using JobWindowNew.Domain.IRepositories;

namespace JobWindowNew.Domain
{
    public interface IUnitOfWork
    {
        IJobRepository JobRepository { get; }
        IJobBoardRepository JobBoardRepository { get; }
        ICountryRepository CountryRepository { get; }
        IStateRepository StateRepository { get; }
        IOccupationRepository OccupationRepository { get; }
        ICategoryRepository CategoryRepository { get; }
        IEmploymentTypeRepository EmploymentTypeRepository { get; }
        ISalaryTypeRepository SalaryTypeRepository { get; }
        IJobOccupationMapRepository JobOccupationMapRepository { get; }
        IApplicantRepository ApplicantRepository { get; }
        IUserRepository UserRepository { get; }
        void Complete();
    }
}
