using System;

namespace APSysData.Repository.Contracts
{
    public interface IUnitOfWork : IDisposable
    {
        IModalityRepository ModalityRepository { get; }
        IPaymentInfoRepository PaymentInfoRepository { get; }
        IPaymentOptionRepository PaymentOptionRepository { get; }
        IPersonalInfoRepository PersonalInfoRepository { get; }
        IPlanTypeRepository PlanTypeRepository { get; }
        IProfileRepository ProfileRepository { get; }
        IRoleRepository RoleRepository { get; }
        ISectionClassRepository SectionClassRepository { get; }
        ITeacherRepository TeacherRepository { get; }
        IUserAgendaRepository UserAgendaRepository { get; }
        IUserContractRepository UserContractRepository { get; }
        IUserRepository UserRepository { get; }
        void Save();
    }
}
