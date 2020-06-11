using Nearsoft.Api.Infrastructure;
using Nearsoft.Infrastructure.Core;

namespace Nearsoft.Api.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly DataContext _context;

        public IEmployeesRepository Employees { get; }

        public IInternsRepository Interns { get; }

        public IBirthdaysRepository Birthdays { get; }

        public IGithubRepository Github { get; }

        public ITripsRepository Trips { get; }

        public IFileRepository Files { get; }

        public UnitOfWork(
            DataContext context,
            IEmployeesRepository employeesRepository,
            IInternsRepository internsRepository,
            IBirthdaysRepository birthdaysRepository,
            IGithubRepository githubRepository,
            ITripsRepository tripsRepository,
            IFileRepository fileRepository)
        {
            _context = context;
            Employees = employeesRepository;
            Birthdays = birthdaysRepository;
            Interns = internsRepository;
            Github = githubRepository;
            Trips = tripsRepository;
            Files = fileRepository;
        }

        public void Complete()
        {
            _context.SaveChanges();
        }
    }
}
