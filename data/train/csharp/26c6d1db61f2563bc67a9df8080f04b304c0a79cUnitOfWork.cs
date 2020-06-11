using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using w_Apartments.Models;

namespace w_Apartments.DAL
{
    public class UnitOfWork : IUnitOfWork, IDisposable
    {
        //db context
        private readonly ApartmentContext _context = new ApartmentContext();

        //repos
        private GenericRepository<Amenities> amenitiesRepository;
        private GenericRepository<Apartment> apartmentRepository;
        private GenericRepository<Description> descriptionRepository;
        private GenericRepository<FilePath> filePathRepository;
        private GenericRepository<HouseRules> houseRulesRepository;
        private GenericRepository<Location> locationRepository;
        private GenericRepository<Prices> pricesRepository;
        private GenericRepository<TheSpace> theSpaceRepository;
        private GenericRepository<User> userRepository;

        #region GenericRepository<Amenities> AmenitiesRepository

        public GenericRepository<Amenities> AmenitiesRepository
        {
            get
            {
                if (this.amenitiesRepository == null)
                    this.amenitiesRepository = new GenericRepository<Amenities>(_context);

                return amenitiesRepository;
            }
        } // end GenericRepository<Amenities> AmenitiesRepository 

        #endregion

        #region GenericRepository<Apartment> ApartmentRepository

        // GenericRepository<Apartment> ApartmentRepository
        public GenericRepository<Apartment> ApartmentRepository
        {
            get
            {
                if (this.apartmentRepository == null)
                    this.apartmentRepository = new GenericRepository<Apartment>(_context);
                return apartmentRepository;
            }
        } // end GenericRepository<Apartment> ApartmentRepository

        #endregion

        #region GenericRepository<Description> DescriptionRepository
        public GenericRepository<Description> DescriptionRepository
        {
            get
            {
                return this.descriptionRepository ??
                       (this.descriptionRepository = new GenericRepository<Description>(_context));
            }
        }
        #endregion

        #region GenericRepository<FilePath> FilePathRepository
        public GenericRepository<FilePath> FilePathRepository
        {
            get
            {
                return this.filePathRepository ?? (this.filePathRepository = new GenericRepository<FilePath>(_context));
            }
        }
        #endregion

        #region GenericRepository<HouseRules> houseRulesRepository

        public GenericRepository<HouseRules> HouseRulesRepository
        {
            get
            {
                return this.houseRulesRepository ??
                       (this.houseRulesRepository = new GenericRepository<HouseRules>(_context));
            }
        }
        #endregion

        #region GenericRepository<Location> LocationRepository
        public GenericRepository<Location> LocationRepository
        {
            get { return this.locationRepository ?? (this.locationRepository = new GenericRepository<Location>(_context)); }
        }
        #endregion

        #region  GenericRepository<Prices> PricesRepository
        public GenericRepository<Prices> PricesRepository
        {
            get { return this.pricesRepository ?? (this.pricesRepository = new GenericRepository<Prices>(_context)); }
        }
        #endregion

        #region GenericRepository<TheSpace> TheSpaceRepository
        public GenericRepository<TheSpace> TheSpaceRepository
        {
            get { return this.theSpaceRepository ?? (this.theSpaceRepository = new GenericRepository<TheSpace>(_context)); }
        }
        #endregion

        #region GenericRepository<User> UserRepository
        public GenericRepository<User> UserRepository
        {
            get { return this.userRepository ?? (this.userRepository = new GenericRepository<User>(_context)); }
        }
        #endregion




        #region Save
        // Save
        public void Save()
        {
            _context.SaveChanges();
        } // end void Save() 
        #endregion

        #region Dispose
        private bool disposed = false;
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    _context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}