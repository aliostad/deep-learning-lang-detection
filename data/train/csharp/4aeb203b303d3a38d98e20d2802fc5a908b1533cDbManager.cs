using PortSimulator.DatabaseManager.Repositories;

namespace PortSimulator.DatabaseManager
{
    public sealed class DbManager
    {
        public readonly CaptainRepository CaptainRepository = new CaptainRepository();
        public readonly CargoRepository CargoRepository = new CargoRepository();
        public readonly CargoTypeRepository CargoTypeRepository = new CargoTypeRepository();
        public readonly CityRepository CityRepository = new CityRepository();
        public readonly PortRepository PortRepository = new PortRepository();
        public readonly ShipRepository ShipRepository = new ShipRepository();
        public readonly TripRepository TripRepository = new TripRepository();
    }
}
