
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LogBook.Business;
using LogBook.DAL;

namespace LogBook.Business
{
    public class instrument_master_class
    {
        LogBookDataContext dt = new LogBookDataContext();
        public void SaveInstrument(tbl_logbook_instrument_master tblObj)
        {

            if (tblObj.id == 0)
                dt.tbl_logbook_instrument_masters.InsertOnSubmit(tblObj);
            
            dt.SubmitChanges();

        }
        public tbl_logbook_instrument_master GetInstrument(int InstrumentId)
        {

            return dt.tbl_logbook_instrument_masters.Where(e => e.id == InstrumentId).SingleOrDefault();


        }
        public List<tbl_logbook_instrument_master> GetInstruments(string strInstrument)
        {

            return dt.tbl_logbook_instrument_masters.ToList();


        }
        public object GetInstrumentList(string strInstrument, int deptid)
        {

            var temp = (from c in dt.tbl_logbook_instrument_masters
                        where
                        (strInstrument == string.Empty || c.name.Contains(strInstrument)) &&
                        (deptid == 0 || c.deptid == deptid)
                        select new

                        {
                            id = c.id,
                            name =c.name,
                            dept = c.tbl_logbook_department_master.name,
                            status = c.IsActive,
                            statusUrl = c.IsActive == true ? "~/Images/Icons/active.png" : "~/Images/Icons/inactive.png",
             
                        }).ToList();


            return temp;

        }
        public void DeleteInstrument(int InstrumentId)
        {
            tbl_logbook_instrument_master obj = dt.tbl_logbook_instrument_masters.Where(e => e.id == InstrumentId).SingleOrDefault();
            if (obj != null)
                dt.tbl_logbook_instrument_masters.DeleteOnSubmit(obj);
            dt.SubmitChanges();

        }


        public void ChangeStatus(int id)
        {
            tbl_logbook_instrument_master obj = dt.tbl_logbook_instrument_masters.Where(e => e.id == id).SingleOrDefault();
            if (obj != null)
                obj.IsActive = obj.IsActive == true ? false : true;
            
            dt.SubmitChanges();
        }
    }
}
