using VRA.DataAccess;

namespace VRA.BusinessLayer
{
    public  class ProcessFactory
    {
        public static ICountryProcess GetCountryProcess()
        {
            return new CountryProcessDb();
        }

        public static ISettingsProcess GetSettingsProcess()
        {
            return new SettingsProcess();
        }

        public static IReportItemProcess GetReportProcess()
        {
            return new ReportItemProcess();
        }

        public static IInfoRepairProcessDb InfoRepairDtoProcess()
        {
            return new InfoRepairProcessDb();
        }

        public static IEnterpriseProcess GetEnterpriseProcess()
        {
            return new EnterpriseProcessDb();
        }

        public static IRepairProcess GetRepairProcess()
        {
            return new RepairProcessDb();
        }

        public static IMachineProcess GetMachinerProcess()
        {
            return new MachineProcessDb();
        }

        public static ITypeMachineProcess GetTypeMachinProcess()
        {
            return new TypeMachineProcessDb();
        }

        public static ITypeRepairProcess GetTypeRepairProcess()
        {
            return new TypeRepairProcessDb();
        }
        
        public static INameRepairProcessDb GetNameRapairProcess()
        {
            return new NameRepairProcessDb();
        }

        public static IReportGenerator GetReport() { return new ReportGenerator(); }
    }
}
