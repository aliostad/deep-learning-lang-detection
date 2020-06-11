using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using NetSteps.Common.Extensions;
using NetSteps.Common.Globalization;
using NetSteps.Data.Entities;
using NetSteps.Data.Entities.Exceptions;
using NetSteps.Encore.Core.IoC;
using NetSteps.Web.Extensions;
using NetSteps.Web.Mvc.Attributes;
using NetSteps.Web.Mvc.Helpers;
using NetSteps.Data.Entities.Business;
using NetSteps.Data.Entities.EntityModels;
using System.Transactions;
using nsCore.Areas.Products.Models;
using NetSteps.Data.Entities.Extensions;
using NetSteps.Data.Entities.Business.HelperObjects.SearchParameters;

namespace nsCore.Areas.Products.Controllers
{
    public class DispatchController : BaseProductsController
    {
        [FunctionFilter("Products", "~/Accounts")]
        public virtual ActionResult Index()
        {
            Dictionary<string, string> startperiod = Periods.GetAllPeriods();

            ViewBag.dcStartPeriod = startperiod;
            ViewBag.dcCampaniaHasta = startperiod;

            return View();
        }

        [OutputCache(CacheProfile = "PagedGridData")]
        public virtual ActionResult Get(bool? status, int page, int pageSize, string orderBy, string description, string periodStart, string periodEnd, string sku, 
            string orderByDirection)
        {
            try
            {
                if (orderByDirection == "Descending")
                {
                    orderByDirection = "desc";
                }
                else
                {
                    orderByDirection = "asc";
                }

                var dispatchs = ProductExtensions.listDispatchGen(new PaginationParameters()
                {
                    PageSize = pageSize,
                    PageIndex = page,
                    OrderBy = orderBy,
                    Order = orderByDirection,
                    Description = description,
                    PeriodStart = periodStart,
                    PeriodEnd = periodEnd,
                    SKU = sku
                });
                if (!dispatchs.Any())
                {
                    return Json(new { result = true, totalPages = 0, page = String.Format("<tr><td colspan=\"6\">{0}</td></tr>", Translation.GetTerm("ThereAreNoDispatchs", "There are no dispatcs")) });
                }

                var builder = new StringBuilder();

                foreach (var dispatch in dispatchs)
                {
                     string controllerName = (dispatch.Description); 
                     string editUrl = string.Format("~/Products/{0}/Edit?dispatchID={1}", "Dispatch", dispatch.DispatchID);
                    builder.Append("<tr>")
                        .AppendCheckBoxCell(value: dispatch.DispatchID.ToString())
                        .AppendLinkCell(editUrl, dispatch.Description)
                        .AppendCell(dispatch.PeriodStart.ToString())
                        .AppendCell(dispatch.PeriodEnd.ToString())
                        .AppendCell(dispatch.DateStart.HasValue ? dispatch.DateStart.Value.ToString("g", CoreContext.CurrentCultureInfo) : string.Empty)
                        .AppendCell(dispatch.DateEnd.HasValue ? dispatch.DateEnd.Value.ToString("g", CoreContext.CurrentCultureInfo) : string.Empty)
                        .AppendCell(dispatch.Situacion.ToString())
                        .AppendCell(dispatch.ListName.ToString())
                        .Append("</tr>");
                }
                return Json(new { result = true, totalPages = dispatchs.TotalPages, page = dispatchs.TotalCount == 0 ? "<tr><td colspan=\"7\">There are no Dispatch</td></tr>" : builder.ToString() });
                 
            }
            catch (Exception ex)
            {
                var exception = EntityExceptionHelper.GetAndLogNetStepsException(ex, NetSteps.Data.Entities.Constants.NetStepsExceptionType.NetStepsApplicationException);
                return Json(new { result = false, message = exception.PublicMessage });
            }
        }

        public virtual ActionResult DeleteDispatchLists(List<int> items)
        {
            foreach (var item in items)
            {
                ProductExtensions.DispatchListDelById(item);
            }

            return Json(new { result = true });
        }

        public virtual ActionResult DeleteDispatch(List<int> items)
        {
            
            try
            {
                string resultado = string.Empty;

                using (TransactionScope trs =new TransactionScope(TransactionScopeOption.Required))
                {
                    foreach (var item in items)
                    {
                        DispatchTable entidad = new DispatchTable();
                        entidad.DispatchID = item;
                        resultado = Dispatch.DeleteDispatch(entidad);
                        if (resultado.Trim().Length > 0)
                        {
                            trs.Dispose();
                            return Json(new { result = false, message = resultado });
                        }
                    }
                    trs.Complete();
                }
                return Json(new { result = true, message = "" });
            }
            catch (Exception ex)
            {
                var exception = EntityExceptionHelper.GetAndLogNetStepsException(ex, NetSteps.Data.Entities.Constants.NetStepsExceptionType.NetStepsApplicationException);
                return JsonError(exception.PublicMessage);
            }
        }

        public virtual ActionResult ChangeDispatchStatus(List<int> items, bool active)
        {
            try
            {
                foreach (var item in items)
                {
                    int RowCount = PaymentsMethodsExtensions.GetApplyPaymentType(active, item);
                }
                return Json(new { result = true });
            }
            catch (Exception ex)
            {
                var exception = EntityExceptionHelper.GetAndLogNetStepsException(ex, NetSteps.Data.Entities.Constants.NetStepsExceptionType.NetStepsApplicationException);
                return JsonError(exception.PublicMessage);
            }
        }


        public virtual ActionResult Create(int? dispatchID)
        {
            Dispatch.typedispatchDisplay();
            TempData["sDispatch"] = from x in PaymentsMethodsExtensions.typedispatchDisplay()
                                    orderby x.Key
                                    select new SelectListItem()
                                    {
                                        Text = x.Value,
                                        Value = x.Key
                                    }; 

            var dispatch = dispatchID.HasValue ? Dispatch.DispatchById(dispatchID.Value) : new DispatchTable { Editable = true };
            return View(dispatch);
        }

        public virtual ActionResult Edit(int? dispatchID)
        {
            try
            {
                TempData["sDispatch"] = from x in PaymentsMethodsExtensions.typedispatchDisplay()
                                        orderby x.Key
                                        select new SelectListItem()
                                        {
                                            Text = x.Value,
                                            Value = x.Key
                                        }; 

                DispatchTable dispatch = new DispatchTable();
                dispatch = Dispatch.DispatchById(Convert.ToInt32(dispatchID));
                dispatch.ProductsQuery = DispatchItems.DispatchItemsByDispatchID(Convert.ToInt32(dispatchID));
                DispatchModel model = new DispatchModel(dispatch);
                return View(model);
            }
            catch (Exception ex)
            {
                var exception = EntityExceptionHelper.GetAndLogNetStepsException(ex, NetSteps.Data.Entities.Constants.NetStepsExceptionType.NetStepsApplicationException);
                throw exception;
            }
        }

        public virtual ActionResult Save(DispatchTable dispatch)
        {
            int resultado = 0;
            try
            {
                if (dispatch.DispatchID > 0)
                {
                    using (TransactionScope tran = new TransactionScope(TransactionScopeOption.Required))
                    { 

                        resultado = Dispatch.UpdateDispatch(dispatch);
                        if (resultado < 1)
                        {
                            tran.Dispose();
                            return Json(new { result = false, message = "No se grabó correctamente en la tabla Dispatch" });
                        }

                        int retora = DispatchItems.DeleteDispatchItemsbyID(dispatch.DispatchID);

                        foreach (var product in dispatch.Products.Where(x=> x.ProductID !=0))
                        {
                            product.DispatchID = dispatch.DispatchID;

                            if (DispatchItems.InsertDispatchItems(product) < 1)
                            {
                                tran.Dispose();
                                return Json(new { result = false, message = "No se grabó correctamente en la tabla Dispatch" });
                            }
                        }
                        resultado = 1;
                        tran.Complete();
                    }
                }
                else
                {
                    using (TransactionScope tran = new TransactionScope(TransactionScopeOption.Required))
                    {
                        int dispatchID = 0;
                        dispatchID = Dispatch.InsertDispatch(dispatch);
                        if (dispatchID < 1)
                        {
                            tran.Dispose();
                            return Json(new { result = false, message = "No se grabó correctamente en la tabla Dispatch" });
                        }
                        foreach (var product in dispatch.Products.Where(x => x.ProductID != 0))
                        {
                            product.DispatchID = dispatchID;

                            if (DispatchItems.InsertDispatchItems(product) < 1)
                            {
                                tran.Dispose();
                                return Json(new { result = false, message = "No se grabó correctamente en la tabla Dispatch" });
                            }
                        }
                        resultado = 1;
                        tran.Complete();
                    }
                }
            }
            catch (Exception ex)
            {
                var exception = EntityExceptionHelper.GetAndLogNetStepsException(ex, NetSteps.Data.Entities.Constants.NetStepsExceptionType.NetStepsApplicationException);
                //tran.Dispose();
                //throw exception;
                return Json(new { result = false, message = ex.Message });
            }
            return Json(new { result = (resultado == 0 ? false : true), message = "" });
        }
    }
}
