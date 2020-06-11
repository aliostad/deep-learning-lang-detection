using SESD.MRP.REF;
using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;

namespace DL
{
    public class DispatchNoteList_DL
    {
        SqlConnection Connection = new SqlConnection();
        public DispatchNoteList_DL(SqlConnection Conn)
        {
            Connection = Conn;
        }
        public int Add(DispatchNoteList obj,string StoreID)
        {
            try
            {


                SqlParameter[] paramList = new SqlParameter[] {
                
                new SqlParameter("@DispatchID", obj.DispatchID),
                new SqlParameter("@FinishProduct", obj.FinishProduct),
                new SqlParameter("@BatchNo", obj.BatchNo),
                new SqlParameter("@Qty", obj.Qty),
                new SqlParameter("@StoreID",StoreID)};


                return Execute.RunSP_RowsEffected(Connection, "SPADD_DispatchNoteList", paramList);

            }
            catch (Exception ex)
            {

                throw new Exception(ex.Message, ex);
            }

        }

        //public int Update(DispatchNoteList objDispatchNoteList)
        //{
        //    tblDispatchNoteListTableAdapter da = new tblDispatchNoteListTableAdapter();
        //    da.Connection = Connection;
        //    try
        //    {
        //        return da.Update(objDispatchNoteList.DispatchedQty,
        //            objDispatchNoteList.DispatchNote.DispatchNoteID,
        //            objDispatchNoteList.Stock.StockID,
        //            objDispatchNoteList.GRN.GRNNo);
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

        //public int Delete(String DispatchNoteID,long StockID,long GRNNO)
        //{
        //    tblDispatchNoteListTableAdapter da = new tblDispatchNoteListTableAdapter();
        //    da.Connection = Connection;
        //    try
        //    {
        //        return da.Delete(DispatchNoteID, StockID, GRNNO);
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


        //public DispatchNoteList Get(String DispatchNoteID, long StockID, long GRNNO)
        //{
        //    tblDispatchNoteListTableAdapter da = new tblDispatchNoteListTableAdapter();
        //    da.Connection = Connection;
        //    MRPDataSet1 dsMRP = new MRPDataSet1();

        //    DispatchNote_DL objDispatchDL = new DispatchNote_DL(Connection);
        //    Stock_DL objStockDL = new Stock_DL(Connection);
        //    GRN_DL objGRNDL = new GRN_DL(Connection);

        //    DispatchNoteList objList = new DispatchNoteList();
        //    try
        //    {
        //        da.FillByID(dsMRP.tblDispatchNoteList, DispatchNoteID, StockID, GRNNO);
        //        foreach (MRPDataSet1.tblDispatchNoteListRow dr in dsMRP.tblDispatchNoteList)
        //        {
        //            objList.DispatchedQty = Convert.ToInt64(dr.Qty);
        //            objList.DispatchNote = objDispatchDL.Get(dr.DispatchNoteNo);
        //            objList.GRN = objGRNDL.Get(Convert.ToInt64(dr.GRNNO));
        //            objList.Stock = objStockDL.Get(Convert.ToInt64(dr.StockID));
        //        }
        //        return objList;
        //    }
        //    catch (Exception ex)
        //    {

        //        throw new Exception(ex.Message, ex);
        //    }
        //    finally
        //    {
        //        da.Dispose();
        //        dsMRP.Dispose();
        //        objGRNDL = null;
        //        objStockDL = null;
        //        objDispatchDL = null;
        //    }
        //}
    }
}
