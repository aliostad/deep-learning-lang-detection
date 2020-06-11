using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Rental.Model.Model;
using System.Data.Entity.Validation;
namespace Rental.Repository
{
    public class UnitOfWork
    {

        private RentalEntities _edm = null;
        private SliderRepository _sliderRepository = null;
        private RoomRepository _roomRepository = null;
        private AreaRepository _areaRepository = null;
        private ServiceRepository _serviceRepository = null;
        private FoodRepository _foodRepository = null;
        private PreferenceRepository _preferenceRepository = null;
        private AboutRepository _aboutRepository = null;
        public UnitOfWork()
        {
            _edm = new RentalEntities();
        }

        public AboutRepository AboutRepository
        {
            get
            {
                if (_preferenceRepository == null)
                {
                    _preferenceRepository = new PreferenceRepository(_edm);
                }
                return _preferenceRepository;
            }
        }

        public PreferenceRepository PreferenceRepository
        {
            get
            {
                if (_preferenceRepository == null)
                {
                    _preferenceRepository = new PreferenceRepository(_edm);
                }
                return _preferenceRepository;
            }
        }

        public ServiceRepository ServiceRepository
        {
            get
            {
                if (_serviceRepository == null)
                {
                    _serviceRepository = new ServiceRepository(_edm);
                }
                return _serviceRepository;
            }
        }

        public FoodRepository FoodRepository
        {
            get
            {
                if (_foodRepository == null)
                {
                    _foodRepository = new FoodRepository(_edm);
                }
                return _foodRepository;
            }
        }
        public RoomRepository RoomRepository
        {
            get
            {
                if (_roomRepository == null)
                {
                    _roomRepository = new RoomRepository(_edm);
                }
                return _roomRepository;
            }
        }

        public AreaRepository AreaRepository
        {
            get
            {
                if (_areaRepository == null)
                {
                    _areaRepository = new AreaRepository(_edm);
                }
                return _areaRepository;
            }
        }

        public SliderRepository SliderRepository
        {
            get
            {
                if (_sliderRepository == null)
                {
                    _sliderRepository = new SliderRepository(_edm);
                }

                return _sliderRepository;
            }
        }


        public int Commit()
        {
            try
            {
                return _edm.SaveChanges();
            }
            catch (DbEntityValidationException dbEx)
            {
                return 0;
            }
        }
    }

}
