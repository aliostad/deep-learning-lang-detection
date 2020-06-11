using System;

namespace Dermatologic.Data
{
    public abstract class AbstractRepositoryFactory
    {
        public static readonly Type REPOSITORY_FACTORY = typeof(RepositoryFactory);
        public static RepositoryFactory Instance(Type factory)
        {
            try
            {
                return (RepositoryFactory)Activator.CreateInstance(factory);

            }
            catch (Exception ex)
            {
                throw new Exception(string.Format("No se crear Factory de Repositorios: -> {0}", ex.Message));
            }
        }

        public abstract IOfficeRepository GetOfficeRepository();

        public abstract IAppointmentRepository GetAppointmentRepository();

        public abstract IMedicalCareRepository GetMedicalCareRepository();

        public abstract IServiceRepository GetServiceRepository();

        public abstract IMenuRepository GetMenuRepository();

        public abstract ISessionRepository GetSessionRepository();

        public abstract IUbigeoRepository GetUbigeoRepository();

        public abstract IUsersInRolesRepository GetUsersInRolesRepository();

        public abstract IUsersRepository GetUsersRepository();

        public abstract IRoleRepository GetRoleRepository();

        public abstract IMenuRoleRepository GetMenuRoleRepository();

        public abstract IMedicationRepository GetMedicationRepository();

        public abstract IRateRepository GetRateRepository();

        public abstract ISupplyRepository GetSupplyRepository();

        public abstract IPersonRepository GetPersonRepository();

        public abstract IPersonTypeRepository GetPersonTypeRepository();

        public abstract IExchangeRateRepository GetExchangeRateRepository();

        public abstract IAccountRepository GetAccountRepository();

        public abstract ICostCenterRepository GetCostCenterRepository();

        public abstract IInvoiceRepository GetInvoiceRepository();

        public abstract ICashMovementRepository GetCashMovementRepository();

        public abstract IPatientInformationRepository GetPatientInformationRepository();

        public abstract IStaffInformationRepository GetStaffInformationRepository();

        public abstract IEmployeeTypeRepository GetEmployeeTypeRepository();

        public abstract ITypeContractRepository GetTypeContractRepository();
    }
}