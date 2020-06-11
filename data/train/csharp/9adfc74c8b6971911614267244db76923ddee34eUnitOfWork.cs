using PSoC.ManagementService.Data.Interfaces;
using PSoC.ManagementService.Data.Models;

namespace PSoC.ManagementService.Data.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {
        private IAccessPointRepository _accessPointRepository;
        private IAdminRepository _adminRepository;
        private IDistrictRepository _districtRepository;
        private ISchoolRepository _schoolRepository;

        /// <summary>
        /// Acces point repository
        /// </summary>
        public IAccessPointRepository AccessPointRepository
        {
            get { return _accessPointRepository ?? (_accessPointRepository = new AccessPointRepository()); }
        }

        /// <summary>
        /// Admin repository
        /// </summary>
        public IAdminRepository AdminRepository
        {
            get { return _adminRepository ?? (_adminRepository = new AdminRepository()); }
        }

        /// <summary>
        /// District repository
        /// </summary>
        public IDistrictRepository DistrictRepository
        {
            get { return _districtRepository ?? (_districtRepository = new DistrictRepository()); }
        }

        /// <summary>
        /// District repository
        /// </summary>
        public ISchoolRepository SchoolRepository
        {
            get { return _schoolRepository ?? (_schoolRepository = new SchoolRepository()); }
        }

        /// <summary>
        /// Get data repositority (in a generic way) for a given data model entity and primary key types
        /// </summary>
        /// <typeparam name="TEntity">Type of data model entity</typeparam>
        /// <typeparam name="TKey">Type of primary key</typeparam>
        /// <returns>Data repository</returns>
        public IDataRepository<TEntity, TKey> GetDataRepository<TEntity, TKey>()
            where TEntity : class
        {
            IDataRepository<TEntity, TKey> dataRepository = null;

            if (typeof(TEntity) == typeof(AccessPointDto))
            {
                dataRepository = AccessPointRepository as IDataRepository<TEntity, TKey>;
            }
            else if (typeof(TEntity) == typeof(AdminDto))
            {
                dataRepository = AdminRepository as IDataRepository<TEntity, TKey>;
            }
            else if (typeof(TEntity) == typeof(DistrictDto))
            {
                dataRepository = DistrictRepository as IDataRepository<TEntity, TKey>;
            }
            else if (typeof(TEntity) == typeof(SchoolDto))
            {
                dataRepository = SchoolRepository as IDataRepository<TEntity, TKey>;
            }

            return dataRepository;
        }
    }
}