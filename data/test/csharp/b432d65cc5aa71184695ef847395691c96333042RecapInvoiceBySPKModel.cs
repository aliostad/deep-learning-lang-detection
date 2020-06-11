using BrawijayaWorkshop.Database.Repositories;

namespace BrawijayaWorkshop.Model
{
    public class RecapInvoiceBySPKModel : RecapInvoiceBaseModel
    {
        public RecapInvoiceBySPKModel(IInvoiceRepository invoiceRepository,
            IInvoiceDetailRepository invoiceDetailRepository,
            ICustomerRepository customerRepository,
            IReferenceRepository referenceRepository,
            ISparepartRepository sparepartRepository,
            IVehicleGroupRepository vehicleGroupRepository,
            IVehicleRepository vehicleRepository)
            : base(invoiceRepository, invoiceDetailRepository, customerRepository,
            referenceRepository, sparepartRepository, vehicleGroupRepository,
            vehicleRepository) { }
    }
}
