using FateDeck.Web.Repositories.Contracts;

namespace FateDeck.Web.Repositories
{
    public class RepositoryFactory : IRepositoryFactory
    {
        public RepositoryFactory():this(null,null,null) {}
        public RepositoryFactory(IDeploymentRepository deploymentRepository, ISchemesRepository schemesRepository, IStrategyRepository strategyRepository)
        {
            DeploymentRepository = deploymentRepository ?? new  DeploymentRepository();
            SchemesRepository = schemesRepository?? new SchemesRepository();
            StrategyRepository = strategyRepository?? new StrategyRepository();
        }

        public IDeploymentRepository DeploymentRepository { get; set; }
        public ISchemesRepository SchemesRepository { get; set; }
        public IStrategyRepository StrategyRepository { get; set; }
    }
}