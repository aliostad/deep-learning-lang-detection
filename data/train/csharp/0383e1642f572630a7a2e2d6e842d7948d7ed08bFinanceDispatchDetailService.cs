using System;
using System.Collections.Generic;
using System.Data;
using DAL;
using MODEL;
using SERVICE.IService;

namespace SERVICE.Service
{
    public class FinanceDispatchDetailService:IFinanceDispatchDetailService
    {
        private HSSNInventoryEntities _context = null;
        public bool SaveFinanceDispatchDetail(List<FinanceDispatchDetailModel> financeDispatchDetailModelsList, int FinanceDispatchid)
        {
            using (_context=new HSSNInventoryEntities())
            {
                try
                {
                    foreach (var rowData in financeDispatchDetailModelsList)
                    {
                        var model = new FinanceDispatchDetail()
                        {
                            FinanceDispatchId = FinanceDispatchid,
                            ProductId = rowData.ProductId,
                            DispatchFromWareHouseId = rowData.DispatchFromWareHouseId,
                            DispatchOrderId = rowData.DispatchOrderId,
                            Quantity = rowData.Quantity,
                            Rate = rowData.Rate,
                            ExcessShortageQuantity = rowData.ExcessShortageQuantity,
                            UnitOfMeasurementId = rowData.UnitOfMeasurementId,

                        };
                        _context.Entry(model).State=EntityState.Added;
                       

                    }
                    _context.SaveChanges();
                    return true;
                }
                catch (Exception)
                {
                    
                    throw;
                }
            }
        }
    }
}