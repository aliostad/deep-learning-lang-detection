using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Transactions;
using DAL;
using MODEL;
using SERVICE.IService;

namespace SERVICE.Service
{
    public class DispatchOrderService : IDispatchOrderService
    {
        private HSSNInventoryEntities _context = null;
        private readonly ICommonService _commonService;

        public DispatchOrderService()
        {
            _commonService = new CommonService();
         //   _context = new HSSNInventoryEntities();
        }

        public bool SaveDispatchOrder(DispatchOrderModel dispatchOrderModel)
        {

            try
            {
                if (dispatchOrderModel.DispatchOrderId == 0)
                {
                    using (var scope = new TransactionScope())
                    {
                        dispatchOrderModel.DispatchOrderId =
                            SaveDispatchOrderSumamry(dispatchOrderModel).DispatchOrderId;
                        if (dispatchOrderModel.DispatchOrderId != 0)
                        {
                            SaveDispatchOrderDetails(dispatchOrderModel.DispatchOrderDetailModels,
                                dispatchOrderModel.DispatchOrderId);
                            //update serical number
                            _commonService.UpdateSerialNumberVoucherType("DO");
                        }
                        scope.Complete();
                    }
                }
                else
                {
                    //write code for edited data
                    using (var scope = new TransactionScope())
                    {
                        if (EditDispatchOrderSumamry(dispatchOrderModel) == true)
                        {
                            if (DeleteDispatchOrderDetail(dispatchOrderModel.DispatchOrderId))
                            {
                                SaveDispatchOrderDetails(dispatchOrderModel.DispatchOrderDetailModels,
                                    dispatchOrderModel.DispatchOrderId);
                            }
                            scope.Complete();
                        }
                    }


                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

            return true;
        }

        public DispatchOrderModel GetDispatchOrderDetailByDispatchOrderId(int dispatchOrderNumber)
        {
             using (_context=new HSSNInventoryEntities())
            {
                DispatchOrderModel DispatchOrderData;
                try
                {
                    var dispatchOrderSummaryModel =
                        _context.DispatchOrders.Where(a => a.DispatchOrderNumber == dispatchOrderNumber)
                            .Select(b => new DispatchOrderModel()
                            {
                                DispatchOrderId = b.DispatchOrderId,
                                DispatchOrderDate = b.DispatchOrderDate,
                                DispatchOrderNumber = b.DispatchOrderNumber,
                                BankGuaranteeAmount = b.BankGuaranteeAmount,
                                OrderRequestedBy = b.OrderRequestedBy,
                                OverDueAmount = b.OverDueAmount,
                                NetDueAmount = b.NetDueAmount,
                                DealerId = b.DealerId
                            }).FirstOrDefault();


                    var dispatchOrderDetailModel = (from b in _context.DispatchOrderDetails
                                                    join a in _context.Products on b.ProductId equals a.ProductId
                                                    where b.DispatchOrderId == dispatchOrderSummaryModel.DispatchOrderId
                                                    select new DispatchOrderDetailModel()
                                                    {
                                                        DispatchOrderId = b.DispatchOrderId,
                                                        DispatchOrderDetailId = b.DispatchOrderDetailId,
                                                        Quantity = b.Quantity,
                                                        Rate = b.Rate,
                                                        ProductId = b.ProductId,
                                                        ProductName = a.ProductName,
                                                        TotalAmount = b.Quantity*b.Rate
                                                        
                                                    }).ToList();

                    DispatchOrderData = dispatchOrderSummaryModel;
                    DispatchOrderData.DispatchOrderDetailModels = dispatchOrderDetailModel;

                    return DispatchOrderData;
                }
                catch (Exception)
                {

                    throw;
                }
            }
        }


        #region Save Edit dispatch order

        private DispatchOrderModel SaveDispatchOrderSumamry(DispatchOrderModel dispatchOrderModel)
        {
             using (_context = new HSSNInventoryEntities())
            {
                try
                {
                    var dispatchOrderSummaryModel = new DispatchOrder()
                    {
                        DispatchOrderNumber = dispatchOrderModel.DispatchOrderNumber,
                        DealerId = dispatchOrderModel.DealerId,
                        BankGuaranteeAmount = dispatchOrderModel.BankGuaranteeAmount,
                        NetDueAmount = dispatchOrderModel.NetDueAmount,
                        OverDueAmount = dispatchOrderModel.OverDueAmount,
                        DispatchOrderDate = dispatchOrderModel.DispatchOrderDate,
                        OrderRequestedBy = dispatchOrderModel.OrderRequestedBy,
                    };
                    _context.Entry(dispatchOrderSummaryModel).State = EntityState.Added;
                    _context.SaveChanges();
                    dispatchOrderModel.DispatchOrderId = dispatchOrderSummaryModel.DispatchOrderId;
                    return dispatchOrderModel;
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    return new DispatchOrderModel();
                }
            }
        }

        public  Boolean EditDispatchOrderSumamry(DispatchOrderModel dispatchOrderModel)
        {
             using (_context = new HSSNInventoryEntities())
            {
                try
                {

                    var data =
                        _context.DispatchOrders.FirstOrDefault(
                            a => a.DispatchOrderId == dispatchOrderModel.DispatchOrderId);


                    if (data != null)
                    {
                        //data.DispatchOrderId = dispatchOrderModel.DispatchOrderId;
                        //data.DispatchOrderNumber = dispatchOrderModel.DispatchOrderNumber;
                        //data.DealerId = dispatchOrderModel.DealerId;
                        //data.DispatchOrderDate = dispatchOrderModel.DispatchOrderDate;
                        //data.BankGuaranteeAmount = dispatchOrderModel.BankGuaranteeAmount;
                        data.IsCheckedByManager =Convert.ToBoolean(   dispatchOrderModel.IsCheckedByManager);
                        //data.CheckedBy = dispatchOrderModel.CheckedBy;
                        data.WhetherDoApproved = dispatchOrderModel.WhetherDoApproved;
                        //data.ApprovedBy = dispatchOrderModel.ApprovedBy;
                        //data.NetDueAmount = dispatchOrderModel.NetDueAmount;
                        //data.OverDueAmount = dispatchOrderModel.OverDueAmount;
                        //data.DispatchOrderDate = dispatchOrderModel.DispatchOrderDate;
                        //data.OrderRequestedBy = dispatchOrderModel.OrderRequestedBy;
                    }

                    _context.Entry(data).State = EntityState.Modified;
                    _context.SaveChanges();
                    //dispatchOrderModel.DispatchOrderId =data.DispatchOrderId;
                    return true;
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    return false; //new DispatchOrderModel();
                }
            }
        }

        private bool DeleteDispatchOrderDetail(int dispatchOrderId)
        {
            using (_context = new HSSNInventoryEntities())
            {
                try
                {
                    _context.Database.ExecuteSqlCommand("DeleteDispatchDetailsByDispatchOrderId " + dispatchOrderId);
                    return true;
                }
                catch (Exception)
                {

                    throw;

                }
            }
        }

        private bool SaveDispatchOrderDetails(List<DispatchOrderDetailModel> dispatchOrderDetailModels,
            int dispatchOrderId)
        {
             using (_context = new HSSNInventoryEntities())
            {
                try
                {
                    foreach (var row in dispatchOrderDetailModels)
                    {
                        var data = new DispatchOrderDetail()
                        {
                            DispatchOrderId = dispatchOrderId,
                            ProductId = row.ProductId,
                            Quantity = row.Quantity,
                            Rate = row.Quantity,
                            UnitId = row.UnitId
                        };
                        _context.Entry(data).State = EntityState.Added;
                        _context.SaveChanges();
                    }

                    return true;
                }
                catch (Exception)
                {

                    throw;
                }
            }
        }


        #endregion




        public List<DispatchOrderModel> Getdispatchorder()
        {
            try
            {
                using (_context= new HSSNInventoryEntities() )
                {

                    var data = (from a in _context.DispatchOrders
                                join b in _context.Dealers on a.DealerId equals b.DealerId
                                select new DispatchOrderModel
                                {
                                    DispatchOrderId = a.DispatchOrderId,
                                    DispatchOrderNumber = a.DispatchOrderNumber,
                                    DealerId = b.DealerId,
                                    DealerName = b.DealerName,
                                    IsCheckedByManager =a.IsCheckedByManager,
                                    ApprovedBy = a.ApprovedBy,
                                    CheckedBy = a.CheckedBy,


                                }).ToList();
                    
                  return data;
                   


                }
            }
            catch (Exception)
            {
                
                throw;
            }
        }


        public List<DispatchOrderDetailModel> GetDispatchOrderDetailByDispatchOrderid(int dispatchorderod)
        {
            try
            {
                using (_context= new HSSNInventoryEntities() )
                {
                    var data = (from a in _context.DispatchOrderDetails
                        join b in _context.Products on a.ProductId equals b.ProductId
                        join c in _context.UnitOfMeasurements on a.UnitId equals c.UnitOfMeasurementId
                        join d in _context.DispatchOrders on a.DispatchOrderId equals d.DispatchOrderId
                        join e in _context.Dealers on d.DealerId equals e.DealerId
                        join f in _context.Regions on e.RegionId equals f.RegionId
                        where a.DispatchOrderId == dispatchorderod
                        select new DispatchOrderDetailModel
                        {
                            DispatchOrderDetailId = a.DispatchOrderDetailId,
                            DispatchOrderId = d.DispatchOrderId,
                            ProductId = b.ProductId,
                            
                            ProductName = b.ProductName,
                            Quantity = a.Quantity,
                            UnitId = c.UnitOfMeasurementId,
                            UnitName = c.UnitName,
                            Rate = a.Rate,

                            //=========
                            DealerName = e.DealerName,
                            Address =e.DealerAddress,
                            MobileNo = e.MobileNo,
                            RegionName =f.RegionName,

                            //=======
                            BankGuaranteeAmountDecimal = d.BankGuaranteeAmount,
                            NetDueAmountDecimal = d.NetDueAmount,
                            OverdueAmountDecimal =d.OverDueAmount,
                            
                        }).ToList();
                    return data;
                   
                }
            }
            catch (Exception)
            {
                
                throw;
            }
        }
        public Boolean UpdateDispatchOrderSumamry(DispatchOrderModel dispatchOrderModel)
        {
            using (_context = new HSSNInventoryEntities())
            {
                try
                {

                    var data =
                        _context.DispatchOrders.FirstOrDefault(
                            a => a.DispatchOrderId == dispatchOrderModel.DispatchOrderId);


                    if (data != null)
                    {
                        //data.DispatchOrderId = dispatchOrderModel.DispatchOrderId;
                        //data.DispatchOrderNumber = dispatchOrderModel.DispatchOrderNumber;
                        //data.DealerId = dispatchOrderModel.DealerId;
                        //data.DispatchOrderDate = dispatchOrderModel.DispatchOrderDate;
                        //data.BankGuaranteeAmount = dispatchOrderModel.BankGuaranteeAmount;
                        data.IsCheckedByManager = Convert.ToBoolean( dispatchOrderModel.IsCheckedByManager);
                        data.CheckedBy = dispatchOrderModel.CheckedBy;
                        //data.NetDueAmount = dispatchOrderModel.NetDueAmount;
                        //data.OverDueAmount = dispatchOrderModel.OverDueAmount;
                        //data.DispatchOrderDate = dispatchOrderModel.DispatchOrderDate;
                        //data.OrderRequestedBy = dispatchOrderModel.OrderRequestedBy;
                    }

                    _context.Entry(data).State = EntityState.Modified;
                    _context.SaveChanges();
                    //dispatchOrderModel.DispatchOrderId =data.DispatchOrderId;
                    return true;
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    return false; //new DispatchOrderModel();
                }
            }
        }

        public List<ProductModel> getproductnameNotcheckedbyfinance()
        {
            try
            {
                using (_context= new HSSNInventoryEntities() )
                {
                    var data = (from a in _context.Products
                        join b in _context.DispatchOrderDetails on a.ProductId equals b.ProductId
                        join c in _context.DispatchOrders on b.DispatchOrderId equals c.DispatchOrderId

                        select new ProductModel()
                        {
                            ProductId = a.ProductId,
                            ProductName = a.ProductName,
                            IsCheckedByManager = c.IsCheckedByManager,
                            WhetherDoApproved =c.WhetherDoApproved,
                            Quantity = b.Quantity,
                            Rate = b.Rate,
                           
                        }).ToList();
                    return data;
                }
            }
            catch (Exception)
            {
                
                throw;
            }
        }

        public List<ProductModel> GetdataByProductId(int Productid)
        {
            try
            {
                using (_context = new HSSNInventoryEntities())
                {
                    var data = (from a in _context.Products
                                join b in _context.DispatchOrderDetails on a.ProductId equals b.ProductId
                                join c in _context.DispatchOrders on b.DispatchOrderId equals c.DispatchOrderId
                                where a.ProductId==Productid
                                select new ProductModel()
                                {
                                    ProductId = a.ProductId,
                                    ProductName = a.ProductName,
                                    IsCheckedByManager = c.IsCheckedByManager,
                                    WhetherDoApproved = c.WhetherDoApproved,
                                    Quantity =b.Quantity,
                                    Rate=b.Rate,
                                }).ToList();
                    return data;
                }
            }
            catch (Exception)
            {

                throw;
            }
        }


       
    }
}