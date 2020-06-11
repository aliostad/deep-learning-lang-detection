using BrawijayaWorkshop.Database.Repositories;

namespace BrawijayaWorkshop.Model
{
    public class RecapInvoiceByVehicleGroupModel : RecapInvoiceBaseModel
    {
        public RecapInvoiceByVehicleGroupModel(IInvoiceRepository invoiceRepository,
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
