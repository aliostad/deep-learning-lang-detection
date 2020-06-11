using FactoryPattern.Context;
using FactoryPattern.Model;

namespace FactoryPattern
{
    class TypesOfVehicles
    {
        private readonly EFContext context;

        private Repository<Car> carRepository;
        private Repository<Motor> motorRepository;
        private Repository<Quad> quadRepository;

        public TypesOfVehicles()
        {
            context = new EFContext();
        }

        public Repository<Car> CarRepository
        {
            get
            {
                if (carRepository == null) carRepository = new Repository<Car>(context);
                return carRepository;
            }
        }

        public Repository<Motor> MotorRepository
        {
            get
            {
                if (motorRepository == null) motorRepository = new Repository<Motor>(context);
                return motorRepository;
            }
        }

        public Repository<Quad> QuadRepository
        {
            get
            {
                if (quadRepository == null) quadRepository = new Repository<Quad>(context);
                return quadRepository;
            }
        } 
    }
}
