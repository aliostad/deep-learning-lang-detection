using BrawijayaWorkshop.Database.Repositories;

namespace BrawijayaWorkshop.Model
{
    public class RecapInvoiceByCustomerModel : RecapInvoiceBaseModel
    {
        public RecapInvoiceByCustomerModel(IInvoiceRepository invoiceRepository,
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
