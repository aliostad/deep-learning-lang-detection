using System.Diagnostics.Contracts;
using MCDomain.DataAccess;

namespace MContracts.Classes
{
    /// <summary>
    /// Вспомогательный класс с поддержкой репозитария
    /// </summary>
    public class RepositoryHolder
    {
        protected RepositoryHolder(IContractRepository repository)
        {
            Contract.Requires(repository != null);
            Repository = repository;
        }

        public IContractRepository Repository { get; private set; }
    }
}