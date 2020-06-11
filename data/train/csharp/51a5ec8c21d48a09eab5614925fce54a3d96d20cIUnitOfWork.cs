using CarReservation.Core.Infrastructure;
using CarReservation.Core.Infrastructure.Base;
using System.Data.Entity;
using System.Threading.Tasks;

namespace CarReservation.Core.IRepository.Base
{
    public interface IUnitOfWork
    {
        ApplicationDbContext DBContext { get; }
        IRequestInfo RequestInfo { get; }

        IColorRepository ColorRepository { get; }
        IRideStatusRepository RideStatusRepository { get; }

        ICountryRepository CountryRepository { get; }
        IStateRepository StateRepository { get; }
        ICityRepository CityRepository { get; }

        IVehicleMakerRepository VehicleMakerRepository { get; }
        IVehicleModelRepository VehicleModelRepository { get; }
        IVehicleBodyTypeRepository VehicleBodyTypeRepository { get; }
        IVehicleFeatureRepository VehicleFeatureRepository { get; }
        IVehicleTransmissionRepository VehicleTransmissionRepository { get; }
        IVehicleAssemblyRepository VehicleAssemblyRepository { get; }

        IVehicleVehicleFeatureRepository VehicleVehicleFeatureRepository { get; }
        IVehicleRepository VehicleRepository { get; }

        ITravelUnitRepository TravelUnitRepository { get; }
        IDistanceUnitRepository DistanceUnitRepository { get; }
        IDriverStatusRepository DriverStatusRepository { get; }

        ICreditCardRepository CreditCardRepository { get; }
        ICurrencyRepository CurrencyRepository { get; }
        ICurrencyLogRepository CurrencyLogRepository { get; }

        IAccountRepository AccountRepository { get; }
        IAccountLogRepository AccountLogRepository { get; }

        IFavouriteLocationRepository FavouriteLocationRepository { get; }
        ILocationLagLonRepository LocationLagLonRepository { get; }

        IFareRepository FareRepository { get; }
        IPackageRepository PackageRepository { get; }
        IPackageTravelUnitRepository PackageTravelUnitRepository { get; }
        IPackageVehicleAssemblyRepository PackageVehicleAssemblyRepository { get; }
        IPackageVehicleBodyTypeRepository PackageVehicleBodyTypeRepository { get; }
        IPackageVehicleFeatureRepository PackageVehicleFeatureRepository { get; }
        IPackageVehicleModelRepository PackageVehicleModelRepository { get; }
        IPackageVehicleTransmissionRepository PackageVehicleTransmissionRepository { get; }

        ISupervisorRepository SupervisorRepository { get; }
        IDriverRepository DriverRepository { get; }

        IDriverLocationRepository DriverLocationRepository { get; }
        IDriverLocationLogRepository DriverLocationLogRepository { get; }

        IDistanceRepository DistanceRepository { get; }
        ITimeTrackerRepository TimeTrackerRepository { get; }
        ICustomerRepository CustomerRepository { get; }
        IRideRepository RideRepository { get; }

        Task<int> SaveAsync();
        int Save();
        DbContextTransaction BeginTransaction();
    }
}
