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

        public static IUserRepository UserRepository
        {
            get
            {
                IUserRepository repository = CallContext.GetData("Peaf.Core.Repository.UserRepository") as UserRepository;
                if (repository == null)
                {
                    repository = new UserRepository();
                    CallContext.SetData("Peaf.Core.Repository.UserRepository", repository);
                }
                return repository;
            }
        }

        public static IRoleRepository RoleRepository
        {
            get
            {
                IRoleRepository repository = CallContext.GetData("Peaf.Core.Repository.RoleRepository") as RoleRepository;
                if (repository == null)
                {
                    repository = new RoleRepository();
                    CallContext.SetData("Peaf.Core.Repository.RoleRepository", repository);
                }
                return repository;
            }
        }

        public static IPermissionRepository PermissionRepository
        {
            get
            {
                IPermissionRepository repository = CallContext.GetData("Peaf.Core.Repository.PermissionRepository") as PermissionRepository;
                if (repository == null)
                {
                    repository = new PermissionRepository();
                    CallContext.SetData("Peaf.Core.Repository.PermissionRepository", repository);
                }
                return repository;
            }
        }

    }
}
