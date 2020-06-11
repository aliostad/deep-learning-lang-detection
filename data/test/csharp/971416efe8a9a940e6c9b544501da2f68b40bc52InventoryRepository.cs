using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityFrameworkInventory.Repository
{
    public class CustomerRepository : Repository<Customer>
    {
    }
	public class SalesOrderRepository : Repository<SalesOrder>
    {
    }
	public class SalesOrderPartRepository : Repository<SalesOrderPart>
    {
    }
	public class PartRepository : Repository<Part>
	{
	}
	public class VendorRepository : Repository<Vendor>
	{ }
	public class SpoilageRepository : Repository<Spoilage>
	{ }
	public class PurchaseOrderRepository : Repository<PurchaseOrder>
	{ }
	public class ReceiptRepository : Repository<Receipt>
	{ }
	public class SalesReturnRepository : Repository<SalesReturn>
	{ }
	public class ShipmentRepository : Repository<Shipment>
	{ }
	public class ShipmentPartRepository : Repository<ShipmentPart>
	{ }
}
