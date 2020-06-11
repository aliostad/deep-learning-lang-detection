using SCADA.RTDB.EntityFramework.DbConfig;

namespace SCADA.RTDB.EntityFramework.Repository
{
    /// <summary>
    /// 
    /// </summary>
    public class RepositoryDecorator:VariableRepository
    {
        /// <summary>
        /// 
        /// </summary>
        protected VariableRepository Repository;
        /// <summary>
        /// 
        /// </summary>
        /// <param name="repositoryBase"></param>
        public void Decorator(VariableRepository repositoryBase)
        {
            Repository = repositoryBase;
        }

        protected RepositoryDecorator(RepositoryConfig variableRepositoryConfig)
            : base(variableRepositoryConfig)
        {
            
        }
        
        /// <summary>
        /// 无参构造函数
        /// </summary>
        protected RepositoryDecorator():base(new RepositoryConfig())
        {
            
        }

        /// <summary>
        /// 重载加载方法
        /// </summary>
        public override void Load()
        {
            if (Repository != null)
            {
                Repository.Load();
            }
        }
        
    }
}