using Peaf.Core.Repository.Impl;
using Peaf.Core.Repository.Interface;
using System.Runtime.Remoting.Messaging;

namespace Peaf.Core.Repository
{
    public static class RepositoryFactory
    {
        public static IEnvironmentVariableRepository EnvironmentVariableRepository
        {
            get
            {
                IEnvironmentVariableRepository repository = CallContext.GetData("Peaf.Core.Repository.EnvironmentVariableRepository") as EnvironmentVariableRepository;
                if (repository == null)
                {
                    repository = new EnvironmentVariableRepository();
                    CallContext.SetData("Peaf.Core.Repository.EnvironmentVariableRepository", repository);
                }
                return repository;
            }
        }

        public static ICategoryRepository CategoryRepository
        {
            get
            {
                ICategoryRepository repository = CallContext.GetData("Peaf.Core.Repository.CategoryRepository") as CategoryRepository;
                if (repository == null)
                {
                    repository = new CategoryRepository();
                    CallContext.SetData("Peaf.Core.Repository.CategoryRepository", repository);
                }
                return repository;
            }
        }

        public static ISimpageRepository SimpageRepository
        {
            get
            {
                ISimpageRepository repository = CallContext.GetData("Peaf.Core.Repository.SimpageRepository") as SimpageRepository;
                if (repository == null)
                {
                    repository = new SimpageRepository();
                    CallContext.SetData("Peaf.Core.Repository.SimpageRepository", repository);
                }
                return repository;
            }
        }

        public static IAttachmentRepository AttachmentRepository
        {
            get
            {
                IAttachmentRepository repository = CallContext.GetData("Peaf.Core.Repository.AttachmentRepository") as AttachmentRepository;
                if (repository == null)
                {
                    repository = new AttachmentRepository();
                    CallContext.SetData("Peaf.Core.Repository.AttachmentRepository", repository);
                }
                return repository;
            }
        }

    }
}
