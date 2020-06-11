using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace mtm.Store.Repository
{
    /// <summary>
    /// 
    /// </summary>
   public class IStoreRepository
   {
       private DepartmentRepository _DepartmentRepository;

       /// <summary>
       /// 
       /// </summary>
       public DepartmentRepository department
       {
           get
           {
               if (_DepartmentRepository == null)
                   _DepartmentRepository = new DepartmentRepository();
               return _DepartmentRepository;
           }
       }
       private ProductRepository _ProductRepository;

       /// <summary>
       /// 
       /// </summary>
       public ProductRepository product
       {
           get
           {
               if (_ProductRepository == null)
                   _ProductRepository = new ProductRepository();
               return _ProductRepository;
           }
       }
       private ProducerRepository _ProducerRepository;

       /// <summary>
       /// 
       /// </summary>
       public ProducerRepository producer
       {
           get
           {
               if (_ProducerRepository == null)
                   _ProducerRepository = new ProducerRepository();
               return _ProducerRepository;
           }
       }
       private FileRepository _FileRepository;

       /// <summary>
       /// 
       /// </summary>
       public FileRepository file
       {
           get
           {
               if (_FileRepository == null)
                   _FileRepository = new FileRepository();
               return _FileRepository;
           }
       }
       private OrderRepository _OrderRepository;

       /// <summary>
       /// 
       /// </summary>
       public OrderRepository order
       {
           get
           {
               if (_OrderRepository == null)
                   _OrderRepository = new OrderRepository();
               return _OrderRepository;
           }
       }
       private ManagerOrderRepository _ManagerOrderRepository;

       /// <summary>
       /// 
       /// </summary>
       public ManagerOrderRepository managerorder
       {
           get
           {
               if (_ManagerOrderRepository == null)
                   _ManagerOrderRepository = new ManagerOrderRepository();
               return _ManagerOrderRepository;
           }
       }
       private SellerRepository _SellerRepository;

       /// <summary>
       /// 
       /// </summary>
       public SellerRepository seller
       {
           get
           {
               if (_SellerRepository == null)
                   _SellerRepository = new SellerRepository();
               return _SellerRepository;
           }
       }
       private ProfileRepository _ProfileRepository;

       /// <summary>
       /// 
       /// </summary>
       public ProfileRepository profile
       {
           get
           {
               if (_ProfileRepository == null)
                   _ProfileRepository = new ProfileRepository();
               return _ProfileRepository;
           }
       }
       private SaleRepository _SaleRepository;

       /// <summary>
       /// 
       /// </summary>
       public SaleRepository sale
       {
           get
           {
               if (_SaleRepository == null)
                   _SaleRepository = new SaleRepository();
               return _SaleRepository;
           }
       }
    }
}
