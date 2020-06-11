using MWF.Mobile.Core.Repositories.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MWF.Mobile.Core.Repositories
{
    public class Repositories : IRepositories
    {

        public Repositories(IApplicationProfileRepository applicationRepository, ICurrentDriverRepository currentDriverRepository, ICustomerRepository customerRepository, IDeviceRepository deviceRepository,
                            IDriverRepository driverRepository, IGatewayQueueItemRepository gatewayQueueItemRepository, ILatestSafetyCheckRepository latestSafetyCheckRepository, ILogMessageRepository logMessageRepository,
                            ISafetyProfileRepository safetyProfileRepository, IVehicleRepository vehicleRepository, ITrailerRepository trailerRepository, IVerbProfileRepository verbProfileRepository, IConfigRepository configRepository, IMobileDataRepository mobileDataRepository)
        {

            ApplicationRepository = applicationRepository;
            ConfigRepository = configRepository;
            CurrentDriverRepository = currentDriverRepository;
            CustomerRepository = customerRepository;
            DeviceRepository = deviceRepository;
            DriverRepository = driverRepository;
            GatewayQueueItemRepository = gatewayQueueItemRepository;
            LatestSafetyCheckRepository = latestSafetyCheckRepository;
            LogMessageRepository = logMessageRepository;
            SafetyProfileRepository = safetyProfileRepository;
            TrailerRepository = trailerRepository;
            VehicleRepository = vehicleRepository;
            VerbProfileRepository = verbProfileRepository;
            TrailerRepository = trailerRepository;
            MobileDataRepository = mobileDataRepository;
        }

        public IApplicationProfileRepository ApplicationRepository
        {
            get;
            private set;
        }

        public ICurrentDriverRepository CurrentDriverRepository
        {
            get;
            private set;
        }

        public ICustomerRepository CustomerRepository
        {
            get;
            private set;
        }

        public IDeviceRepository DeviceRepository
        {
            get;
            private set;
        }

        public IDriverRepository DriverRepository
        {
            get;
            private set;
        }

        public IGatewayQueueItemRepository GatewayQueueItemRepository
        {
            get;
            private set;
        }

        public ILatestSafetyCheckRepository LatestSafetyCheckRepository
        {
            get;
            private set;
        }

        public ILogMessageRepository LogMessageRepository
        {
            get;
            private set;
        }

        public ISafetyProfileRepository SafetyProfileRepository
        {
            get;
            private set;
        }

        public ITrailerRepository TrailerRepository
        {
            get;
            private set;
        }

        public IVehicleRepository VehicleRepository
        {
            get;
            private set;
        }

        public IVerbProfileRepository VerbProfileRepository
        {
            get;
            private set;
        }

        public IConfigRepository ConfigRepository
        {
            get;
            private set;
        }

        public IMobileDataRepository MobileDataRepository
        {
            get;
            private set;
        }
    }
}
