using DAL;
using System.Web.Mvc;

namespace AIMS_TAsk.Controllers
{
    public class BaseOrderController : Controller
    {
        public IorederRepository orederRepository;
        public IwarehouseRepository warehouseRepository;
        public ICategoryRepository categoryRepository;
        public IbranchRepositoryl branchRepository;
        public IitemRepository itemRepository;
        public IbillOrderRepository billOrderRepository;

        public BaseOrderController()
        {
            orederRepository = new OrderRepository();
            warehouseRepository = new WarehouseRepository();
            branchRepository = new BrancheRepository();
            itemRepository = new ItemRepository();
            categoryRepository = new CategoryRepository();
            billOrderRepository = new BillRepository();
        }
    }
}
