using System.Collections.Generic;
using System.Linq;
using System.Web;
using VersionR.Models;

namespace VersionR.DAL
{
    public class Repositories
    {
        private VersionRContext context = new VersionRContext(new VersionR.Models.VersionR());

        private GenericRepository<Customer_Modules> customerModulesRepository;
        private GenericRepository<Download> downloadRepository;
        private ManualRepository manualRepository;
        private ModuleRepository moduleRepository;
        private GenericRepository<Role> roleRepository;
        private UserRepository userRepository;
        private VersionRepository versionRepository;

        private bool disposed = false;

        public GenericRepository<Download> DownloadRepository
        {
            get
            {
                if (downloadRepository == null)
                {
                    downloadRepository = new GenericRepository<Download>(context);
                }
                return downloadRepository;
            }
        }

        public ManualRepository ManualRepository
        {
            get
            {
                if (manualRepository == null)
                {
                    manualRepository = new ManualRepository(context);
                }
                return manualRepository;
            }
        }

        public ModuleRepository ModuleRepository
        {
            get
            {
                if (moduleRepository == null)
                {
                    moduleRepository = new ModuleRepository(context, this);
                }
                return moduleRepository;
            }
        }

        public GenericRepository<Role> RoleRepository
        {
            get
            {
                if (roleRepository == null)
                {
                    roleRepository = new GenericRepository<Role>(context);
                }
                return roleRepository;
            }
        }

        public UserRepository UserRepository
        {
            get
            {
                if (userRepository == null)
                {
                    userRepository = new UserRepository(context, this);
                }
                return userRepository;
            }
        }

        public VersionRepository VersionRepository
        {
            get
            {
                if (versionRepository == null)
                {
                    versionRepository = new VersionRepository(context, this);
                }
                return versionRepository;
            }
        }

        public GenericRepository<Customer_Modules> CustomerModulesRepository
        {
            get
            {
                if (customerModulesRepository == null)
                {
                    customerModulesRepository = new GenericRepository<Customer_Modules>(context);
                }
                return customerModulesRepository;
            }
        }

        public void Save()
        {
            context.SaveChanges();
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed && disposing)
            {
                context.Dispose();
            }
        }

        public void Dispose()
        {
            Dispose(true);
            System.GC.SuppressFinalize(this);
        }
    }
}