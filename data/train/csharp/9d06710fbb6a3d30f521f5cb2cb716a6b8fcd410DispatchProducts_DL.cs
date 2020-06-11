using SESD.MRP.REF;
using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;

namespace DL
{
    public class DispatchProducts_DL
    {
        SqlConnection Connection = new SqlConnection();
        public DispatchProducts_DL(SqlConnection Conn)
        {
            Connection = Conn;
        }
        //public int Add(DispatchProducts objDispatchProducts)
        //{
        //    tblDispatchProductsTableAdapter da = new tblDispatchProductsTableAdapter();
        //    da.Connection = Connection;
        //    try
        //    {
        //        return Convert.ToInt32(da.SPUPDATE_GRN_DISPATCH_ISSUE_FinishProduct(objDispatchProducts.DispatchNote.DispatchNoteID,
        //            objDispatchProducts.DispatchFinishProduct.FinishProductCode,
        //            objDispatchProducts.DispatchQty,"MAIN"));
        //    }
        //    catch (Exception ex)
        //    {

        //        throw new Exception(ex.Message, ex);
        //    }
        //    finally
        //    {
        //        da.Dispose();
        //    }
        //}

        //public int Update(DispatchProducts objDispatchProducts)
        //{
        //    tblDispatchProductsTableAdapter da = new tblDispatchProductsTableAdapter();
        //    da.Connection = Connection;
        //    try
        //    {
        //        return da.Update(objDispatchProducts.DispatchQty,
        //            objDispatchProducts.DispatchNote.DispatchNoteID,
        //            objDispatchProducts.DispatchFinishProduct.FinishProductCode);
        //    }
        //    catch (Exception ex)
        //    {

        //        throw new Exception(ex.Message, ex);
        //    }
        //    finally
        //    {
        //        da.Dispose();
        //    }
        //}

        //public int Delete(String DispatchNoteID,String FinishProuctCode )
        //{
        //    tblDispatchProductsTableAdapter da = new tblDispatchProductsTableAdapter();
        //    da.Connection = Connection;
        //    try
        //    {
        //        return da.Delete(DispatchNoteID, FinishProuctCode);
        //    }
        //    catch (Exception ex)
        //    {

        //        throw new Exception(ex.Message, ex);
        //    }
        //    finally
        //    {
        //        da.Dispose();
        //    }
        //}

        //public DispatchProductsCollec Get()
        //{
        //    return null;
        //}

        //public DispatchProducts Get(String DispatchNoteID, String FinishProuctCode)
        //{
        //    tblDispatchProductsTableAdapter da = new tblDispatchProductsTableAdapter();
        //    da.Connection = Connection;
        //    MRPDataSet1 dsMRP = new MRPDataSet1();

        //    DispatchNote_DL objDispatchDL = new DispatchNote_DL(Connection);
        //    FinishProduct_DL objFinishProductDL = new FinishProduct_DL(Connection);

        //    DispatchProducts objDispatchProducts = new DispatchProducts();

        //    try
        //    {
        //        da.FillByID(dsMRP.tblDispatchProducts,DispatchNoteID,FinishProuctCode);
        //        foreach (MRPDataSet1.tblDispatchProductsRow dr in dsMRP.tblDispatchProducts)
        //        {
        //            objDispatchProducts.DispatchFinishProduct = objFinishProductDL.Get(dr.DispatchFinishProductID);
        //            objDispatchProducts.DispatchNote = objDispatchDL.Get(dr.DispatchNoteNo);
        //            objDispatchProducts.DispatchQty = Convert.ToDecimal(dr.DispatchQty);
        //        }
        //        return objDispatchProducts;
        //    }
        //    catch (Exception ex)
        //    {

        //        throw new Exception(ex.Message, ex);
        //    }
        //    finally
        //    {
        //        da.Dispose();
        //        objDispatchDL = null;
        //        objFinishProductDL = null;
        //        dsMRP.Dispose();
        //    }
        //}
    }
}
