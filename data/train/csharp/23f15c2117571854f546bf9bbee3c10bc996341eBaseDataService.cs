using Robot.Models.Repositories;

namespace Robot.Application.Services.DataServices
{
    public class BaseDataService
    {
        private IManufacturerRepository _manufacturerRepository { get; set; }

        public IManufacturerRepository ManufacturerRepository
        {
            get { return _manufacturerRepository ?? (_manufacturerRepository = new ManufacturerRepository()); }
        }

        private ICountryRepository _countryRepository { get; set; }

        public ICountryRepository CountryRepository
        {
            get { return _countryRepository ?? (_countryRepository = new CountryRepository()); }
        }

        private IModelRepository _modelRepository { get; set; }

        public IModelRepository ModelRepository
        {
            get { return _modelRepository ?? (_modelRepository = new ModelRepository()); }
        }

        private ISetPointRepository _setPointRepository { get; set; }
        public ISetPointRepository SetPointRepository
            {
                get
                {
                    return _setPointRepository ?? (_setPointRepository = new SetPointRepository());
                }
            }

        private IRoadTestRepository _roadTestRepository { get; set; }
        public IRoadTestRepository RoadTestRepository
            {
                get
                {
                    return _roadTestRepository ?? (_roadTestRepository = new RoadTestRepository());
                }
            }
        }
}
