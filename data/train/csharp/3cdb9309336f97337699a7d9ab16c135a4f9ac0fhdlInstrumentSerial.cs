using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;
using SmsMis.Models.Console.Common;
using SmsMis.Models.Console.Client;
using SmsMis.Models.Console.Handlers.Admin;

namespace SmsMis.Models.Console.Handlers.Fee
{
    public class hdlInstrumentSerial : DbContext
    {public hdlInstrumentSerial() : base("name=ValencySGIEntities") { }
        public IList<InstrumentSerial> SelectAll()
        {
            SmsMis.Models.Console.Handlers.Admin.SmsMisDB db = new SmsMis.Models.Console.Handlers.Admin.SmsMisDB();
            return db.InstrumentSerial.ToList();
        }
        //public InstrumentSerial SelectByIDs(int companyID)
        //{
        //    SmsMis.Models.Console.Handlers.Admin.SmsMisDB db = new SmsMis.Models.Console.Handlers.Admin.SmsMisDB();
        //    return db.Branch.ToList().Where(s => s.CompanyCode == companyID).ToList();
        //}

        public void save(InstrumentSerial InstrumentSerial, string userId)
        {
            try
            {
                using (var context = new SmsMisDB())
                {
                    var entry = context.Entry(InstrumentSerial);
                    if (entry != null)
                    {
                        InstrumentSerial.AddDateTime = DateTime.Now;
                        InstrumentSerial.AddByUserId = userId;

                        if (InstrumentSerial.InstrumentTypeSerial == 0)
                        {
                            InstrumentSerial.InstrumentTypeSerial = Functions.getNextPk("InstrumentSerial", "InstrumentTypeSerial", string.Concat(" WHERE CompanyCode=", InstrumentSerial.CompanyCode, " AND BranchCode=", InstrumentSerial.BranchCode, " AND AccountCode='", InstrumentSerial.AccountCode, "' AND InstrumentTypeCode=", InstrumentSerial.InstrumentTypeCode));

                            entry.State = EntityState.Added;
                        }
                        else entry.State = EntityState.Modified;

                        context.SaveChanges();
                    }
                }
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException ex)
            {
                //throw ex;
            }
            catch (Exception ex)
            {
                // throw ex;
            }
        }
        public void delete(InstrumentSerial InstrumentSerial)
        {
            try
            {
                var context = new SmsMisDB();
                context.InstrumentSerial.Attach(InstrumentSerial);
                var entry = context.Entry(InstrumentSerial);
                if (entry != null)
                {
                    entry.State = EntityState.Deleted;
                    context.SaveChanges();
                }
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException ex)
            {
                //throw SmsMis.Models.Console.Common.ExceptionTranslater.translate(ex);
                throw ex;
            }
            catch (Exception ex)
            {
                //throw SmsMis.Models.Console.Common.ExceptionTranslater.translate(ex);
                throw ex;
            }
        }
    }
}



