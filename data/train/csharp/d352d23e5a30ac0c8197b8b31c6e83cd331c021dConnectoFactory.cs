namespace Connecto.Repositories
{
    public static class ConnectoFactory
    {
        public static VendorRepository VendorRepository
        {
            get { return new VendorRepository(); }
        }
        public static ProductRepository ProductRepository
        {
            get { return new ProductRepository(); }
        }
        public static CompanyRepository CompanyRepository
        {
            get { return new CompanyRepository(); }
        }
        public static LocationRepository LocationRepository
        {
            get { return new LocationRepository(); }
        }
        public static SupplierRepository SupplierRepository
        {
            get { return new SupplierRepository(); }
        }
        public static EmployeeRepository EmployeeRepository
        {
            get { return new EmployeeRepository(); }
        }
        public static MeasureRepository MeasureRepository
        {
            get { return new MeasureRepository(); }
        }
        public static CurrencyRepository CurrencyRepository
        {
            get { return new CurrencyRepository(); }
        }
        public static ContactRepository ContactRepository
        {
            get { return new ContactRepository(); }
        }
    }
}