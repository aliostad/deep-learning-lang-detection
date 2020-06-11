using KarmicEnergy.Core.Repositories;
using System;

namespace KarmicEnergy.Core.Persistence
{
    public interface IKEUnitOfWork : IDisposable
    {
        int Complete();

        IDataSyncRepository DataSyncRepository { get; }

        ILogRepository LogRepository { get; }
        ILogTypeRepository LogTypeRepository { get; }
        IActionTypeRepository ActionTypeRepository { get; }

        IAddressRepository AddressRepository { get; }
        ICityRepository CityRepository { get; }
        ICountryRepository CountryRepository { get; }

        ICustomerRepository CustomerRepository { get; }
        ICustomerSettingRepository CustomerSettingRepository { get; }
        ICustomerUserRepository CustomerUserRepository { get; }
        ICustomerUserSettingRepository CustomerUserSettingRepository { get; }
        ICustomerUserSiteRepository CustomerUserSiteRepository { get; }

        IUserRepository UserRepository { get; }

        IContactRepository ContactRepository { get; }

        ISiteRepository SiteRepository { get; }

        IPondRepository PondRepository { get; }

        ITankRepository TankRepository { get; }
        ITankModelRepository TankModelRepository { get; }
        IGeometryRepository GeometryRepository { get; }

        ISensorRepository SensorRepository { get; }
        ISensorItemRepository SensorItemRepository { get; }
        ISensorTypeRepository SensorTypeRepository { get; }
        ISensorItemEventRepository SensorItemEventRepository { get; }
        IItemRepository ItemRepository { get; }

        ISensorGroupRepository SensorGroupRepository { get; }
        IGroupRepository GroupRepository { get; }

        ITriggerRepository TriggerRepository { get; }
        ITriggerContactRepository TriggerContactRepository { get; }
        IOperatorRepository OperatorRepository { get; }
        IOperatorTypeRepository OperatorTypeRepository { get; }
        ISeverityRepository SeverityRepository { get; }

        IAlarmRepository AlarmRepository { get; }
        IAlarmHistoryRepository AlarmHistoryRepository { get; }

        IUnitRepository UnitRepository { get; }
        IUnitTypeRepository UnitTypeRepository { get; }

        IStickConversionRepository StickConversionRepository { get; }
        IStickConversionValueRepository StickConversionValueRepository { get; }

        INotificationRepository NotificationRepository { get; }
        INotificationTemplateRepository NotificationTemplateRepository { get; }
        INotificationTypeRepository NotificationTypeRepository { get; }
    }
}