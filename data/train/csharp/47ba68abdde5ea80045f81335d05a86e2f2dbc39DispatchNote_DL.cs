using SESD.MRP.REF;
using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;

namespace DL
{
    public class DispatchNote_DL
    {
        SqlConnection Connection = new SqlConnection();

        public DispatchNote_DL(SqlConnection Conn)
        {
            Connection = Conn;
        }

        public int Add(DispatchNote obj)
        {
            try
            {
                SqlParameter[] paramList = new SqlParameter[] {
                
                new SqlParameter("@DispatchID", obj.DispatchID),
                new SqlParameter("@DistributorID", obj.DistributorID),
                new SqlParameter("@TerritoryID", obj.TerritoryID),
                new SqlParameter("@EnteredBy", obj.EnteredBy)
                };

                return Execute.RunSP_RowsEffected(Connection, "SPADD_DispatchNote", paramList);

            }
            catch (Exception ex)
            {

                throw new Exception(ex.Message, ex);
            }
        }

        //public int Update(DispatchNote objDispatchNote)
        //{
        //    //tblDispatchNoteTableAdapter da = new tblDispatchNoteTableAdapter();
        //    //da.Connection = Connection;
        //    //try
        //    //{
        //    //    return da.Update(objDispatchNote.DispatchNoteDate, objDispatchNote.DispatchNoteEnterdBy.EmployeeID,
        //    //        objDispatchNote.DispatchNoteEnterdDate, objDispatchNote.DispatchNoteID);
        //    //}
        //    //catch (Exception ex)
        //    //{

        //    //    throw new Exception(ex.Message, ex);
        //    //}
        //    //finally
        //    //{
        //    //    da.Dispose();
        //    //}
        //}

        //public int Delete(String DispatchNoteID)
        //{
        //    //tblDispatchNoteTableAdapter da = new tblDispatchNoteTableAdapter();
        //    //da.Connection = Connection;
        //    //try
        //    //{
        //    //    return da.Delete(DispatchNoteID);
        //    //}
        //    //catch (Exception ex)
        //    //{

        //    //    throw new Exception(ex.Message, ex);
        //    //}
        //    //finally
        //    //{
        //    //    da.Dispose();
        //    //}
        //}

       

        //public DispatchNote Get(String DispatchNoteID)
        //{
        //    tblDispatchNoteTableAdapter da = new tblDispatchNoteTableAdapter();
        //    da.Connection = Connection;
        //    MRPDataSet1 dsMRP = new MRPDataSet1();
        //    Employee_DL objEmpDL = new Employee_DL(Connection);


        //    DispatchNote objDispatch = new DispatchNote();
        //    try
        //    {
        //        da.FillByID(dsMRP.tblDispatchNote, DispatchNoteID);
        //        foreach (MRPDataSet1.tblDispatchNoteRow dr in dsMRP.tblDispatchNote)
        //        {
        //            objDispatch.DispatchNoteDate = dr.DispatchDate;
        //            objDispatch.DispatchNoteEnterdBy = objEmpDL.Get(dr.DispatchEnterdBy);
        //            objDispatch.DispatchNoteEnterdDate = dr.DispatchEnterdDate;
        //            objDispatch.DispatchNoteID = dr.DispatchNoteID;

        //        }
        //        return objDispatch;
        //    }
        //    catch (Exception ex)
        //    {

        //        throw new Exception(ex.Message, ex);
        //    }
        //    finally
        //    {
        //        da.Dispose();
        //        dsMRP.Dispose();
        //        objEmpDL = null;
        //    }
        //}
    }
}
