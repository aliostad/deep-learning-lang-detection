using System;
using System.Threading;
using System.Threading.Tasks;
using IDAL.Interfaces.IRepositories;

namespace IDAL.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        #region Properties

        IExternalLoginRepository ExternalLoginRepository { get; }
        IRoleRepository RoleRepository { get; }
        IUserRepository UserRepository { get; }
        IEmployerRepository EmployerRepository { get; }
        IAdminRepository AdminRepository { get; }
        IEmployeeRepository EmployeeRepository { get; }
        IAdvisorRepository AdvisorRepository { get; }
        IAnswerRepository AnswerRepository { get; }
        IAlertRepository AlertRepository { get; }
        IPageRepository PageRepository { get; }
        IQuestionRepository QuestionRepository { get; }
        IReportRepository ReportRepository { get; }

        #endregion

        #region Methods
        
        Task<int> SaveChanges();
        Task<int> SaveChanges(CancellationToken cancellationToken);

        #endregion
    }
}