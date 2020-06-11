using Gestmank.Interfaces.IRepositories;

namespace Gestmank.Services
{
    public class HouseService
    {
        private readonly IHouseRepository _housesRepository;
        private readonly IHouseFeatureRepository _featuresRepository;
        private readonly IHouseFeaturesCategoryRepository _categoriesRepository;



        public HouseService(IHouseRepository housesRepository,
            IHouseFeatureRepository featuresRepository,
            IHouseFeaturesCategoryRepository categoriesRepository)
        {
            _housesRepository = housesRepository;
            _featuresRepository = featuresRepository;
            _categoriesRepository = categoriesRepository;
        }
    }
}