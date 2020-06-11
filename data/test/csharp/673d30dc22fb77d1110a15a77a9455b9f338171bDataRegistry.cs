using BusConductor.Data.Repositories;
using BusConductor.Domain.RepositoryContracts;
using StructureMap.Configuration.DSL;

namespace BusConductor.Data.Core
{
    public class DataRegistry : Registry
    {
        public DataRegistry()
        {
            Configure(x =>
            {
                For<IUserRepository>().Use<UserRepository>();
                For<IRoleRepository>().Use<RoleRepository>();
                For<ITaskRepository>().Use<TaskRepository>();
                For<ITaskTypeRepository>().Use<TaskTypeRepository>();
                For<IBusRepository>().Use<BusRepository>();
                For<IBookingRepository>().Use<BookingRepository>();
                For<IVoucherRepository>().Use<VoucherRepository>();
                For<IEnquiryRepository>().Use<EnquiryRepository>();
            });
        }
    }
}
