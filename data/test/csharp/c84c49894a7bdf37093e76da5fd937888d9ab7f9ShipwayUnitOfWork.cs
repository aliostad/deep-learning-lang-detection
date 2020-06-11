using ShipwayBusiness.DatabaseContext;
using ShipwayBusiness.Repository.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShipwayBusiness.Repository.UnitOfWork
{
    public class ShipwayUnitOfWork : IDisposable
    {
        private readonly ShipwayContext _context = new ShipwayContext();

        private AgencyRepository _agencyRepository;
        private DistrictRepository _districtRepository;
        private ExhibitionRepositoty _exhibitionRepositoty;
        private ExhibitionStatusRepository _exhibitionStatusRepository;
        private KindServiceRepository _kindServiceRepository;
        private KindTimeReceivedRepository _kindTimeReceivedRepository;
        private NoteRequiredRepository _noteRequiredRepository;
        private ProvinceRepository _provinceRepository;
        private ServiceChargeRepository _serviceChargeRepository;
        private ShipperRepository _shipperRepository;
        private UserRepository _userRepository;
        private WardRepository _wardRepository;
        private RouterRepository _routerRepository;
        private HistoryTripRepository _historyTripRepository;

        public AgencyRepository AgencyRepository
        {
            get { return _agencyRepository ?? (_agencyRepository = new AgencyRepository(_context)); }
        }

        public DistrictRepository DistrictRepository
        {
            get { return _districtRepository ?? (_districtRepository = new DistrictRepository(_context)); }
        }

        public ExhibitionRepositoty ExhibitionRepositoty
        {
            get { return _exhibitionRepositoty ?? (_exhibitionRepositoty = new ExhibitionRepositoty(_context)); }
        }

        public ExhibitionStatusRepository ExhibitionStatusRepository
        {
            get { return _exhibitionStatusRepository ?? (_exhibitionStatusRepository = new ExhibitionStatusRepository(_context)); }
        }

        public KindServiceRepository KindServiceRepository
        {
            get { return _kindServiceRepository ?? (_kindServiceRepository = new KindServiceRepository(_context)); }
        }

        public KindTimeReceivedRepository KindTimeReceivedRepository
        {
            get { return _kindTimeReceivedRepository ?? (_kindTimeReceivedRepository = new KindTimeReceivedRepository(_context)); }
        }

        public NoteRequiredRepository NoteRequiredRepository
        {
            get { return _noteRequiredRepository ?? (_noteRequiredRepository = new NoteRequiredRepository(_context)); }
        }

        public ProvinceRepository ProvinceRepository
        {
            get { return _provinceRepository ?? (_provinceRepository = new ProvinceRepository(_context)); }
        }

        public ServiceChargeRepository ServiceChargeRepository
        {
            get { return _serviceChargeRepository ?? (_serviceChargeRepository = new ServiceChargeRepository(_context)); }
        }

        public ShipperRepository ShipperRepository
        {
            get { return _shipperRepository ?? (_shipperRepository = new ShipperRepository(_context)); }
        }

        public UserRepository UserRepository
        {
            get { return _userRepository ?? (_userRepository = new UserRepository(_context)); }
        }

        public WardRepository WardRepository
        {
            get { return _wardRepository ?? (_wardRepository = new WardRepository(_context)); }
        }

        public RouterRepository RouterRepository
        {
            get { return _routerRepository ?? (_routerRepository = new RouterRepository(_context)); }
        }

        public HistoryTripRepository HistoryTripRepository
        {
            get { return _historyTripRepository ?? (_historyTripRepository = new HistoryTripRepository(_context)); }
        }

        private bool _disposed;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    _context.Dispose();
                }
            }
            _disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}