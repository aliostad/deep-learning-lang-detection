using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace DMS.DAL
{
    public class UnitOfWork:IDisposable
    {
        private DMPEntities context=new DMPEntities();
        private GenericRepository<Account> accountRepository;
        private GenericRepository<AccountProfile> accountProfileRepository;
        private GenericRepository<Role> roleRepository;
        //private GenericRepository<City> cityRepository;
        private GenericRepository<DeliveryMan> deliveryManRepository;
        private GenericRepository<DeliverySchedule> deliveryScheduleRepository;
        private GenericRepository<DeliveryScheduleDetail> deliveryScheduleDetailRepository;
        private GenericRepository<District> districtRepository;

        private GenericRepository<Drug> drugRepository;
        private GenericRepository<DrugCompany> drugCompanyRepository;
        private GenericRepository<DrugOrder> drugOrderRepository;
        private GenericRepository<DrugOrderDetail> drugOrderDetailRepository;
        private GenericRepository<Drugstore> drugstoreRepository;
        //private GenericRepository<DrugstoreGroup> drugstoreGroupRepository;
        private GenericRepository<DrugstoreType> drugstoreTypeRepository;
        //private GenericRepository<DrugstoreManagerDetail> drugstoreManagerDetailRepository;
        private GenericRepository<DrugType> drugTypeRepository;
        private GenericRepository<Price> priceRepositoryRepository;
        private GenericRepository<Unit> unitRepositoryRepository;
        private GenericRepository<DiscountRate> discountRateRepositoryRepository;
        //private GenericRepository<Tag> tagRepository;
        private GenericRepository<Payment> paymentRepository;
        private GenericRepository<City> cityRepository;
        //private GenericRepository<FavoriteList> favoriteListRepository;
        //private GenericRepository<FavoriteListDetail> favoriteListDetailsRepository;

        //public GenericRepository<DrugstoreGroup>DrugstoreGroupRepository
        //{
        //    get
        //    {
        //        if (this.drugstoreGroupRepository == null)
        //        {
        //            this.drugstoreGroupRepository = new GenericRepository<DrugstoreGroup>(context);
        //        }
        //        return drugstoreGroupRepository;
        //    }
        //}
        //public GenericRepository<FavoriteList> FavoriteListRepository
        //{
        //    get
        //    {
        //        if (this.favoriteListRepository == null)
        //        {
        //            this.favoriteListRepository = new GenericRepository<FavoriteList>(context);
        //        }
        //        return favoriteListRepository;
        //    }
        //}
        //public GenericRepository<FavoriteListDetail> FavoriteListDetailRepository
        //{
        //    get
        //    {
        //        if (this.favoriteListDetailsRepository == null)
        //        {
        //            this.favoriteListDetailsRepository = new GenericRepository<FavoriteListDetail>(context);
        //        }
        //        return favoriteListDetailsRepository;
        //    }
        //}
        public GenericRepository<DeliveryScheduleDetail> DeliveryScheduleDetailsRepository
        {
            get
            {
                if (this.deliveryScheduleDetailRepository == null)
                {
                    this.deliveryScheduleDetailRepository = new GenericRepository<DeliveryScheduleDetail>(context);
                }
                return deliveryScheduleDetailRepository;
            }
        }
        public GenericRepository<Payment> PaymentRepository
        {
            get
            {
                if (this.paymentRepository == null)
                {
                    this.paymentRepository = new GenericRepository<Payment>(context);
                }
                return paymentRepository;
            }
        }
        public GenericRepository<Account> AccountRepository
        {
            get
            {
                if (this.accountRepository == null)
                {
                    this.accountRepository=new GenericRepository<Account>(context);
                }
                return accountRepository;
            }
        }
        public GenericRepository<AccountProfile> AccountProfileRepository
        {
            get
            {
                if (this.accountProfileRepository == null)
                {
                    this.accountProfileRepository = new GenericRepository<AccountProfile>(context);
                }
                return accountProfileRepository;
            }
        }
        public GenericRepository<Role> RoleRepository
        {
            get
            {
                if (this.roleRepository == null)
                {
                    this.roleRepository = new GenericRepository<Role>(context);
                }
                return roleRepository;
            }
        }
        //public GenericRepository<City> CityRepository
        //{
        //    get
        //    {
        //        if (this.cityRepository == null)
        //        {
        //            this.cityRepository = new GenericRepository<City>(context);
        //        }
        //        return cityRepository;
        //    }
        //}
        public GenericRepository<DeliveryMan> DeliverymanRepository
        {
            get
            {
                if (this.deliveryManRepository == null)
                {
                    this.deliveryManRepository = new GenericRepository<DeliveryMan>(context);
                }
                return deliveryManRepository;
            }
        }
        public GenericRepository<DeliverySchedule> DeliveryScheduleRepository
        {
            get
            {
                if (this.deliveryScheduleRepository == null)
                {
                    this.deliveryScheduleRepository = new GenericRepository<DeliverySchedule>(context);
                }
                return deliveryScheduleRepository;
            }
        }
        public GenericRepository<District> DistrictRepository
        {
            get
            {
                if (this.districtRepository == null)
                {
                    this.districtRepository = new GenericRepository<District>(context);
                }
                return districtRepository;
            }
        }
        public GenericRepository<DrugOrder> DrugOrderRepository
        {
            get
            {
                if (this.drugOrderRepository == null)
                {
                    this.drugOrderRepository = new GenericRepository<DrugOrder>(context);
                }
                return drugOrderRepository;
            }
        }
        public GenericRepository<DrugOrderDetail> DrugOrderDetailRepository
        {
            get
            {
                if (this.drugOrderDetailRepository == null)
                {
                    this.drugOrderDetailRepository = new GenericRepository<DrugOrderDetail>(context);
                }
                return drugOrderDetailRepository;
            }
        }
        //public GenericRepository<DrugstoreManagerDetail> DrugStoreManagerDetailRepository
        //{
        //    get
        //    {
        //        if (this.drugstoreManagerDetailRepository == null)
        //        {
        //            this.drugstoreManagerDetailRepository = new GenericRepository<DrugstoreManagerDetail>(context);
        //        }
        //        return DrugStoreManagerDetailRepository;
        //    }
        //}
        public GenericRepository<Drugstore> DrugStoreRepository
        {
            get
            {
                if (this.drugstoreRepository == null)
                {
                    this.drugstoreRepository = new GenericRepository<Drugstore>(context);
                }
                return drugstoreRepository;
            }
        }
        public GenericRepository<DrugstoreType> DrugStoreTypeRepository
        {
            get
            {
                if (this.drugstoreTypeRepository == null)
                {
                    this.drugstoreTypeRepository = new GenericRepository<DrugstoreType>(context);
                }
                return drugstoreTypeRepository;
            }
        }
        public GenericRepository<Drug> DrugRepository
        {
            get
            {
                if (this.drugRepository == null)
                {
                    this.drugRepository = new GenericRepository<Drug>(context);
                }
                return drugRepository;
            }
        }
        public GenericRepository<DrugType> DrugTypeRepository
        {
            get
            {
                if (this.drugTypeRepository == null)
                {
                    this.drugTypeRepository = new GenericRepository<DrugType>(context);
                }
                return drugTypeRepository;
            }
        }
        public GenericRepository<DrugCompany> DrugCompanyRepository
        {
            get
            {
                if (this.drugCompanyRepository == null)
                {
                    this.drugCompanyRepository = new GenericRepository<DrugCompany>(context);
                }
                return drugCompanyRepository;
            }
        }
        public GenericRepository<Price> PriceRepository
        {
            get
            {
                if (this.priceRepositoryRepository == null)
                {
                    this.priceRepositoryRepository = new GenericRepository<Price>(context);
                }
                return priceRepositoryRepository;
            }
        }
        public GenericRepository<Unit> UnitRepository
        {
            get
            {
                if (this.unitRepositoryRepository == null)
                {
                    this.unitRepositoryRepository = new GenericRepository<Unit>(context);
                }
                return unitRepositoryRepository;
            }
        }
        public GenericRepository<DiscountRate> DiscountRateRepository
        {
            get
            {
                if (this.discountRateRepositoryRepository == null)
                {
                    this.discountRateRepositoryRepository = new GenericRepository<DiscountRate>(context);
                }
                return discountRateRepositoryRepository;
            }
        }
        public GenericRepository<City> CityRepository
        {
            get
            {
                if (this.cityRepository == null)
                {
                    this.cityRepository = new GenericRepository<City>(context);
                }
                return cityRepository;
            }
        }
        //public GenericRepository<Tag> TagRepository
        //{
        //    get
        //    {
        //        if (this.tagRepository == null)
        //        {
        //            this.tagRepository = new GenericRepository<Tag>(context);
        //        }
        //        return tagRepository;
        //    }
        //}


        public void Save()
        {
            context.SaveChanges();
        }

        private bool disposed = false;
        public void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    context.Dispose();
                }
            }
            this.disposed = true;
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}