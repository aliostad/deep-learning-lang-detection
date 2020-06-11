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
    public class hdlInstrumentSerialMaster : DbContext
    {public hdlInstrumentSerialMaster() : base("name=ValencySGIEntities") { }
    public IList<object> SelectAll(int CompanyCode)
        {
            SmsMis.Models.Console.Handlers.Admin.SmsMisDB db = new SmsMis.Models.Console.Handlers.Admin.SmsMisDB();
            //return db.InstrumentSerialMaster.Where(s=>s.CompanyCode== CompanyCode).ToList();
            var otherItems = (from st in db.InstrumentSerialMaster
                              
                              select new
                              {
                                  CompanyCode= st.CompanyCode ,
                                  BranchCode = st.BranchCode,
                                  AccountCode = st.AccountCode,
                                  InstrumentTypeCode =st.InstrumentTypeCode ,
                                  StartingInstrumentNo=st.StartingInstrumentNo,
                                  EndingInstrumentNo = st.EndingInstrumentNo,
                                  IssueDate = st.IssueDate,
                                  Status = st.Status,
                                  AddByUserId=st.AddByUserId,
                                  AddDateTime = st.AddDateTime
                                  
                              }).Where(a => a.CompanyCode == CompanyCode ).ToArray();
            return otherItems;
        //
        }
        //public InstrumentSerialMaster SelectByIDs(int companyID)
        //{
        //    SmsMis.Models.Console.Handlers.Admin.SmsMisDB db = new SmsMis.Models.Console.Handlers.Admin.SmsMisDB();
        //    return db.Branch.ToList().Where(s => s.CompanyCode == companyID).ToList();
        //}
        public void save(InstrumentSerialDetail InstrumentSerialDetail, string userId)
        {
            try
            {
                using (var context = new SmsMisDB())
                {
                    var entrymain = context.Entry(InstrumentSerialDetail);
                    if (entrymain != null)
                    {
                        InstrumentSerialDetail.CancelledDateTime = DateTime.Now;
                        InstrumentSerialDetail.CancelledByUserId = userId;
                        //List <InstrumentSerialDetail> Cancelled = new List<InstrumentSerialDetail>();
                        //for (int i = Convert.ToInt32(InstrumentSerialDetail.StartingInstrumentNo); i <= Convert.ToInt32(InstrumentSerialDetail.EndingInstrumentNo); i++)
                        //{

                        //InstrumentSerialDetail.CompanyCode = InstrumentSerialMaster.CompanyCode;
                        //InstrumentSerialDetail.BranchCode = InstrumentSerialMaster.BranchCode;
                        //InstrumentSerialDetail.AccountCode = InstrumentSerialMaster.AccountCode;
                        InstrumentSerialDetail.Cancelled = true;
                        //InstrumentSerialDetail.InstrumentTypeCode = InstrumentSerialMaster.InstrumentTypeCode;
                        //InstrumentSerialDetail.InstrumentNo = i;
                        //InstrumentSerialMaster.InstrumentSerialDetail.Add(detail);
                    }
                    //if (isNew)
                    //{
                    //    //InstrumentSerialMaster.InstrumentTypeSerial = Functions.getNextPk("InstrumentSerialMaster", "InstrumentTypeSerial", string.Concat(" WHERE CompanyCode=", InstrumentSerialMaster.CompanyCode, " AND BranchCode=", InstrumentSerialMaster.BranchCode, " AND AccountCode='", InstrumentSerialMaster.AccountCode, "' AND InstrumentTypeCode=", InstrumentSerialMaster.InstrumentTypeCode));
                    //    entrymain.State = EntityState.Added;
                    //}
                    //else
                    //{
                    //if (InstrumentSerialDetail != null && InstrumentSerialDetail.Count > 0)
                    //{
                    //    InstrumentSerialDetail.ToList().ForEach(i => { i.CompanyCode = CompanyCode; });
                    //    InstrumentSerialDetail.ToList().ForEach(i => { i.BranchCode = BranchCode; });
                    //    InstrumentSerialDetail.ToList().ForEach(i => { i.AccountCode = AccountCode; });
                    //    InstrumentSerialDetail.ToList().ForEach(i => { i.InstrumentTypeCode = InstrumentTypeCode; });
                    //}
                    entrymain.State = EntityState.Modified;
                    //}
                    //if (InstrumentSerialDetail != null && InstrumentSerialDetail.Count > 0)
                    //InstrumentSerialMaster.InstrumentSerialDetail.ToList<InstrumentSerialDetail>().ForEach(entry => context.Entry(entry).State = EntityState.Added);
                    //context.InstrumentSerialDetail.ToList().Where(i => i.BranchCode == InstrumentSerialMaster.BranchCode && i.CompanyCode == InstrumentSerialMaster.CompanyCode && i.AccountCode == InstrumentSerialMaster.AccountCode && i.InstrumentTypeCode == InstrumentSerialMaster.InstrumentTypeCode).ToList<InstrumentSerialDetail>().ForEach(entry => context.Entry(entry).State = EntityState.Deleted);

                    context.SaveChanges();
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
        public void save(InstrumentSerialMaster InstrumentSerialMaster, string userId, bool isNew)
        {
            try
            {
                using (var context = new SmsMisDB())
                {
                    var entrymain = context.Entry(InstrumentSerialMaster);
                    if (entrymain != null)
                    {
                        InstrumentSerialMaster.AddDateTime = DateTime.Now;
                        InstrumentSerialMaster.AddByUserId = userId;
                        InstrumentSerialMaster.InstrumentSerialDetail = new List<InstrumentSerialDetail>();
                        for (int i = Convert.ToInt32(InstrumentSerialMaster.StartingInstrumentNo); i <= Convert.ToInt32(InstrumentSerialMaster.EndingInstrumentNo); i++)
                        {
                            InstrumentSerialDetail detail = new InstrumentSerialDetail();
                            detail.CompanyCode = InstrumentSerialMaster.CompanyCode;
                            detail.BranchCode = InstrumentSerialMaster.BranchCode;
                            detail.AccountCode = InstrumentSerialMaster.AccountCode;
                            detail.Cancelled = false;
                            detail.InstrumentTypeCode = InstrumentSerialMaster.InstrumentTypeCode;
                            detail.InstrumentNo = i;
                            InstrumentSerialMaster.InstrumentSerialDetail.Add(detail);
                        }
                        if (isNew)
                        {
                            //InstrumentSerialMaster.InstrumentTypeSerial = Functions.getNextPk("InstrumentSerialMaster", "InstrumentTypeSerial", string.Concat(" WHERE CompanyCode=", InstrumentSerialMaster.CompanyCode, " AND BranchCode=", InstrumentSerialMaster.BranchCode, " AND AccountCode='", InstrumentSerialMaster.AccountCode, "' AND InstrumentTypeCode=", InstrumentSerialMaster.InstrumentTypeCode));
                            entrymain.State = EntityState.Added;
                        }
                        else
                        {
                            if (InstrumentSerialMaster.InstrumentSerialDetail != null && InstrumentSerialMaster.InstrumentSerialDetail.Count > 0)
                            {
                                InstrumentSerialMaster.InstrumentSerialDetail.ToList().ForEach(i => { i.CompanyCode = InstrumentSerialMaster.CompanyCode; });
                                InstrumentSerialMaster.InstrumentSerialDetail.ToList().ForEach(i => { i.BranchCode = InstrumentSerialMaster.BranchCode; });
                                InstrumentSerialMaster.InstrumentSerialDetail.ToList().ForEach(i => { i.AccountCode = InstrumentSerialMaster.AccountCode; });
                                InstrumentSerialMaster.InstrumentSerialDetail.ToList().ForEach(i => { i.InstrumentTypeCode = InstrumentSerialMaster.InstrumentTypeCode; });
                            }
                            entrymain.State = EntityState.Modified;
                        }
                        if (InstrumentSerialMaster.InstrumentSerialDetail != null && InstrumentSerialMaster.InstrumentSerialDetail.Count > 0)
                            InstrumentSerialMaster.InstrumentSerialDetail.ToList<InstrumentSerialDetail>().ForEach(entry => context.Entry(entry).State = EntityState.Added);
                        context.InstrumentSerialDetail.ToList().Where(i => i.BranchCode == InstrumentSerialMaster.BranchCode && i.CompanyCode == InstrumentSerialMaster.CompanyCode && i.AccountCode == InstrumentSerialMaster.AccountCode && i.InstrumentTypeCode == InstrumentSerialMaster.InstrumentTypeCode).ToList<InstrumentSerialDetail>().ForEach(entry => context.Entry(entry).State = EntityState.Deleted);

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
        public void delete(InstrumentSerialMaster InstrumentSerialMaster)
        {
            try
            {
                var context = new SmsMisDB();
                context.InstrumentSerialMaster.Attach(InstrumentSerialMaster);
                var entry = context.Entry(InstrumentSerialMaster);
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



