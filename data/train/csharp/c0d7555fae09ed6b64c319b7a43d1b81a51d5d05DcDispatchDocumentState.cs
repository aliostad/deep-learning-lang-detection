using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using amis._Common;
using amis.Models;

namespace amis._DataLayer.GeneratedCode
{
    public partial class DcDispatchProviderDocumentState
    {
        public void Copy(DispatchProviderDocumentState objSource, ref DispatchProviderDocumentState objDestination)
        {
            objDestination.DispatchProviderDocumentStateId = objSource.DispatchProviderDocumentStateId;
            objDestination.DispatchProviderDocumentStateName = objSource.DispatchProviderDocumentStateName;
        }

        public DispatchProviderDocumentState Save(DispatchProviderDocumentState objSource, out string errorMessage)
        {
            errorMessage = "";
            try
            {
                using (var context = new Entity())
                {
                    using (TransactionScope transaction = new TransactionScope())
                    {
                        DispatchProviderDocumentState service = context.DispatchProviderDocumentState.Where(r => r.DispatchProviderDocumentStateName.ToUpper() == objSource.DispatchProviderDocumentStateName.ToUpper() && r.DispatchProviderDocumentStateId != objSource.DispatchProviderDocumentStateId).FirstOrDefault();
                        if (service != null) return (DispatchProviderDocumentState)ErrorController.SetErrorMessage("Repeated state name", out errorMessage);

                        DispatchProviderDocumentState row = context.DispatchProviderDocumentState.Where(r => r.DispatchProviderDocumentStateId == objSource.DispatchProviderDocumentStateId).FirstOrDefault();
                        if (row == null)
                        {
                            row = new DispatchProviderDocumentState();
                            Copy(objSource, ref row);
                            context.DispatchProviderDocumentState.Add(row);
                        }
                        else
                        {
                            Copy(objSource, ref row);
                        }
                        context.SaveChanges();
                        transaction.Complete();
                        return row;
                    }
                }
            }
            catch (Exception ex)
            {
                errorMessage = ErrorController.GetErrorMessage(ex);
                return null;
            }
        }

        public bool ExistsDispatchProviderDocumentState(int DispatchProviderDocumentStateId, out string errorMessage)
        {
            errorMessage = "";
            try
            {
                DispatchProviderDocumentState obj = null;
                using (var context = new Entity())
                {
                    obj = context.DispatchProviderDocumentState.Where(r => r.DispatchProviderDocumentStateId != DispatchProviderDocumentStateId).FirstOrDefault();
                    if (obj == null)
                    {
                        return false;
                    }
                    return true;
                }
            }
            catch (Exception ex)
            {
                errorMessage = ErrorController.GetErrorMessage(ex);
                return false;
            }
        }

        public List<DispatchProviderDocumentState> GetDispatchProviderDocumentStateList(out string errorMessage)
        {
            errorMessage = "";
            try
            {
                using (var context = new Entity())
                {
                    List<DispatchProviderDocumentState> list = context.DispatchProviderDocumentState.OrderBy(a => a.DispatchProviderDocumentStateName).ToList();
                    return list;
                }
            }
            catch (Exception ex)
            {
                errorMessage = ErrorController.GetErrorMessage(ex);
                return null;
            }
        }

        public List<TsDropDownItem> GetComboList(out string errorMessage)
        {
            errorMessage = "";
            try
            {
                using (var context = new Entity())
                {
                    List<TsDropDownItem> list =
                        (from obj in context.DispatchProviderDocumentState
                         select new TsDropDownItem()
                         {
                             ComboId = obj.DispatchProviderDocumentStateId.ToString(),
                             ComboName = obj.DispatchProviderDocumentStateName
                         }).ToList();
                    return list;
                }
            }
            catch (Exception ex)
            {
                errorMessage = ErrorController.GetErrorMessage(ex);
                return null;
            }
        }

        public IEnumerable<object> GetTableList(out string errorMessage)
        {
            errorMessage = "";
            try
            {
                using (var context = new Entity())
                {
                    IEnumerable<object> list =
                        (from DispatchProviderDocumentState in context.DispatchProviderDocumentState
                         select new
                         {
                             DispatchProviderDocumentStateId = DispatchProviderDocumentState.DispatchProviderDocumentStateId,
                             DispatchProviderDocumentStateName = DispatchProviderDocumentState.DispatchProviderDocumentStateName

                         }).ToList();
                    return list;
                }
            }
            catch (Exception ex)
            {
                errorMessage = ErrorController.GetErrorMessage(ex);
                return null;
            }
        }

        public CommonEnums.DeletedRecordStates DeleteDispatchProviderDocumentState(int IDispatchProviderDocumentStateId, out string errorMessage)
        {
            try
            {
                using (var context = new Entity())
                {
                    errorMessage = "";
                    DispatchProviderDocumentState obj = context.DispatchProviderDocumentState.Where(r => r.DispatchProviderDocumentStateId == IDispatchProviderDocumentStateId).FirstOrDefault();
                    if (obj == null)
                    {
                        return CommonEnums.DeletedRecordStates.NotFound;
                    }
                    context.DispatchProviderDocumentState.Remove(obj);
                    context.SaveChanges();
                    return CommonEnums.DeletedRecordStates.DeletedOk;
                }
            }
            catch (Exception ex)
            {
                errorMessage = ErrorController.GetErrorMessage(ex);
                return CommonEnums.DeletedRecordStates.NotDeleted;
            }
        }

    }
}