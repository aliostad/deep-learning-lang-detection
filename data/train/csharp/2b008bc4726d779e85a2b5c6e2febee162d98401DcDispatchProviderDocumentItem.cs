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
    public partial class DcDispatchProviderDocumentItem
    {
        public void Copy(DispatchProviderDocumentItem objSource, ref DispatchProviderDocumentItem objDestination)
        {
            objDestination.DispatchProviderDocumentItemId = objSource.DispatchProviderDocumentItemId;
            objDestination.DispatchProviderDocumentId = objSource.DispatchProviderDocumentId;
            objDestination.AssetUniqueIdentificationId = objSource.AssetUniqueIdentificationId;
            objDestination.ManufacturerYear = objSource.ManufacturerYear;
            objDestination.DeclaratedAmount = objSource.DeclaratedAmount;
            objDestination.ReceptionAmount = objSource.ReceptionAmount;
            objDestination.DispatchProviderDocumentStateId = objSource.DispatchProviderDocumentStateId;
            objDestination.Observation = objSource.Observation;
            objDestination.ItemCost = objSource.ItemCost;
            objDestination.AssignedAmount = objSource.AssignedAmount;
            objDestination.ApplicationId = objSource.ApplicationId;
            objDestination.Dot = objSource.Dot;
        }

        public DispatchProviderDocumentItem Save(DispatchProviderDocumentItem objSource, out string errorMessage)
        {
            errorMessage = "";
            try
            {
                using (var context = new Entity())
                {
                    CommonEnums.PageActionEnum action = new CommonEnums.PageActionEnum();

                    using (TransactionScope transaction = new TransactionScope())
                    {
                        
                        DispatchProviderDocumentItem row = context.DispatchProviderDocumentItem.Where(r => r.DispatchProviderDocumentItemId == objSource.DispatchProviderDocumentItemId).FirstOrDefault();
                        if (row == null)
                        {
                            row = new DispatchProviderDocumentItem();
                            Copy(objSource, ref row);
                            context.DispatchProviderDocumentItem.Add(row);
                            action = CommonEnums.PageActionEnum.Create;

                        }
                        else
                        {
                            Copy(objSource, ref row);
                            action = CommonEnums.PageActionEnum.Update;

                        }
                        context.SaveChanges();
                        //string description = "Se ha añadido un nuevo item a la guia con id:"+row.DispatchProviderDocumentId+", el id del item es:" + row.DispatchProviderDocumentItemId;
                        //new DcPageLog().Save(action, description);
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

        public bool ExistsDispatchProviderDocumentItem(int DispatchProviderDocumentItemId, out string errorMessage)
        {
            errorMessage = "";
            try
            {
                DispatchProviderDocumentItem obj = null;
                using (var context = new Entity())
                {
                    obj = context.DispatchProviderDocumentItem.Where(r => r.DispatchProviderDocumentItemId != DispatchProviderDocumentItemId).FirstOrDefault();
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

        public List<DispatchProviderDocumentItem> GetDispatchProviderDocumentItemList(out string errorMessage)
        {
            errorMessage = "";
            try
            {
                using (var context = new Entity())
                {
                    List<DispatchProviderDocumentItem> list = context.DispatchProviderDocumentItem.ToList();
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
                        (from DispatchProviderDocumentItem in context.DispatchProviderDocumentItem
                         join dispatch in context.DispatchProviderDocument on DispatchProviderDocumentItem.DispatchProviderDocumentId equals dispatch.DispatchProviderDocumentId
                         join identification in context.AssetUniqueIdentification on DispatchProviderDocumentItem.AssetUniqueIdentificationId equals identification.AssetUniqueIdentificationId
                         join type in context.AssetType on identification.AssetTypeId equals type.AssetTypeId
                         join origin in context.Origin on identification.OriginId equals origin.OriginId
                         join brand in context.Brand on identification.AssetModel.BrandId equals brand.BrandId
                         join model in context.AssetModel on identification.AssetModelId equals model.AssetModelId
                         select new
                         {
                             DispatchProviderDocumentItemId = DispatchProviderDocumentItem.DispatchProviderDocumentItemId,
                             ManufacturerYear = DispatchProviderDocumentItem.ManufacturerYear,
                             AssetTypeId = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetTypeId,
                             AssetTypeName = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetType.AssetTypeName,
                             OriginId = DispatchProviderDocumentItem.AssetUniqueIdentification.OriginId,
                             OriginName = DispatchProviderDocumentItem.AssetUniqueIdentification.Origin.OriginName,
                             BrandId = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModel.BrandId,
                             BrandName = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModel.Brand.BrandName,
                             AssetModelId = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModelId,
                             AssetModelName = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModel.AssetModelName,
                             DeclaratedAmount = DispatchProviderDocumentItem.DeclaratedAmount,
                             ReceptionAmount = DispatchProviderDocumentItem.ReceptionAmount,
                             AssignedAmount = DispatchProviderDocumentItem.AssignedAmount,
                             DispatchProviderDocumentStateId= DispatchProviderDocumentItem.DispatchProviderDocumentStateId,
                             DispatchProviderDocumentStateName = DispatchProviderDocumentItem.DispatchProviderDocumentState.DispatchProviderDocumentStateName,
                             Observation = DispatchProviderDocumentItem.Observation,
                             ItemCost = DispatchProviderDocumentItem.ItemCost
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

        public CommonEnums.DeletedRecordStates DeleteDispatchProviderDocumentItem(int IDispatchProviderDocumentItemId, out string errorMessage)
        {
            try
            {
                using (var context = new Entity())
                {
                    errorMessage = "";
                    DispatchProviderDocumentItem obj = context.DispatchProviderDocumentItem.Where(r => r.DispatchProviderDocumentItemId == IDispatchProviderDocumentItemId).FirstOrDefault();
                    if (obj == null)
                    {
                        return CommonEnums.DeletedRecordStates.NotFound;
                    }
                    context.DispatchProviderDocumentItem.Remove(obj);
                    context.SaveChanges();
                    string description = "Se ha eliminado el item con el id:" + obj.DispatchProviderDocumentItemId;
                    new DcPageLog().Save(CommonEnums.PageActionEnum.Delete, description);
                    return CommonEnums.DeletedRecordStates.DeletedOk;
                }
            }
            catch (Exception ex)
            {
                errorMessage = ErrorController.GetErrorMessage(ex);
                return CommonEnums.DeletedRecordStates.NotDeleted;
            }
        }
		
		public bool HasDispatchProviderDocument(int DispatchProviderDocumentId, ref DispatchProviderDocumentItem first)
        {
            using (var context = new Entity())
            {
                first = context.DispatchProviderDocumentItem.Where(r => r.DispatchProviderDocumentId != DispatchProviderDocumentId).FirstOrDefault();
                if (first == null)
                {
                    return false;
                }
                return true;
            }
        }

        public IEnumerable<object> GetTableListByFilter(int id, out string errorMessage)
        {
            errorMessage = "";
            try
            {
                using (var context = new Entity())
                {
                    IEnumerable<object> list =
                        (from DispatchProviderDocumentItem in context.DispatchProviderDocumentItem.Where(r=> r.DispatchProviderDocumentId == id)
                         join dispatch in context.DispatchProviderDocument on DispatchProviderDocumentItem.DispatchProviderDocumentId equals dispatch.DispatchProviderDocumentId
                         join identification in context.AssetUniqueIdentification on DispatchProviderDocumentItem.AssetUniqueIdentificationId equals identification.AssetUniqueIdentificationId
                         join type in context.AssetType on identification.AssetTypeId equals type.AssetTypeId
                         join origin in context.Origin on identification.OriginId equals origin.OriginId
                         join brand in context.Brand on identification.AssetModel.BrandId equals brand.BrandId
                         join model in context.AssetModel on identification.AssetModelId equals model.AssetModelId
                         select new
                         {
                             DispatchProviderDocumentItemId = DispatchProviderDocumentItem.DispatchProviderDocumentItemId,
                             ManufacturerYear = DispatchProviderDocumentItem.ManufacturerYear,
                             AssetTypeId = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetTypeId,
                             AssetTypeName = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetType.AssetTypeName,
                             OriginId = DispatchProviderDocumentItem.AssetUniqueIdentification.OriginId,
                             OriginName = DispatchProviderDocumentItem.AssetUniqueIdentification.Origin.OriginName,
                             BrandId = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModel.BrandId,
                             BrandName = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModel.Brand.BrandName,
                             AssetModelId = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModelId,
                             AssetModelName = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModel.AssetModelName,
                             DeclaratedAmount = DispatchProviderDocumentItem.DeclaratedAmount,
                             ReceptionAmount = DispatchProviderDocumentItem.ReceptionAmount,
                             AssignedAmount = DispatchProviderDocumentItem.AssignedAmount,
                             DispatchProviderDocumentStateId = DispatchProviderDocumentItem.DispatchProviderDocumentStateId,
                             DispatchProviderDocumentStateName = DispatchProviderDocumentItem.DispatchProviderDocumentState.DispatchProviderDocumentStateName,
                             Observation = DispatchProviderDocumentItem.Observation,
                             ItemCost = DispatchProviderDocumentItem.ItemCost
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

        public IEnumerable<object> GetTableListByFilterValidate(int id, out string errorMessage)
        {
            errorMessage = "";
            try
            {
                using (var context = new Entity())
                {
                    IEnumerable<object> list =
                        (from DispatchProviderDocumentItem in context.DispatchProviderDocumentItem.Where(r => r.DispatchProviderDocumentId == id && r.DispatchProviderDocumentStateId==1)
                         join dispatch in context.DispatchProviderDocument on DispatchProviderDocumentItem.DispatchProviderDocumentId equals dispatch.DispatchProviderDocumentId
                         join identification in context.AssetUniqueIdentification on DispatchProviderDocumentItem.AssetUniqueIdentificationId equals identification.AssetUniqueIdentificationId
                         join type in context.AssetType on identification.AssetTypeId equals type.AssetTypeId
                         join origin in context.Origin on identification.OriginId equals origin.OriginId
                         join brand in context.Brand on identification.AssetModel.BrandId equals brand.BrandId
                         join model in context.AssetModel on identification.AssetModelId equals model.AssetModelId
                         select new
                         {
                             DispatchProviderDocumentItemId = DispatchProviderDocumentItem.DispatchProviderDocumentItemId,
                             ManufacturerYear = DispatchProviderDocumentItem.ManufacturerYear,
                             AssetTypeId = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetTypeId,
                             AssetTypeName = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetType.AssetTypeName,
                             OriginId = DispatchProviderDocumentItem.AssetUniqueIdentification.OriginId,
                             OriginName = DispatchProviderDocumentItem.AssetUniqueIdentification.Origin.OriginName,
                             BrandId = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModel.BrandId,
                             BrandName = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModel.Brand.BrandName,
                             AssetModelId = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModelId,
                             AssetModelName = DispatchProviderDocumentItem.AssetUniqueIdentification.AssetModel.AssetModelName,
                             DeclaratedAmount = DispatchProviderDocumentItem.DeclaratedAmount - DispatchProviderDocumentItem.AssignedAmount,
                             ReceptionAmount = DispatchProviderDocumentItem.ReceptionAmount,
                             AssignedAmount = DispatchProviderDocumentItem.AssignedAmount,
                             DispatchProviderDocumentStateId = DispatchProviderDocumentItem.DispatchProviderDocumentStateId,
                             DispatchProviderDocumentStateName = DispatchProviderDocumentItem.DispatchProviderDocumentState.DispatchProviderDocumentStateName,
                             Observation = DispatchProviderDocumentItem.Observation,
                             ItemCost = DispatchProviderDocumentItem.ItemCost
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
        
        public DispatchProviderDocumentItem GetObjById(int id)
        {
            using (var context = new Entity())
            {

                DispatchProviderDocumentItem obj = (from o in context.DispatchProviderDocumentItem
                                                    where o.DispatchProviderDocumentItemId == id
                                                    select o).FirstOrDefault();
                return obj;
            }
        }

        public bool HasAUI(int AUIId, ref DispatchProviderDocumentItem first)
        {
            using (var context = new Entity())
            {
                first = context.DispatchProviderDocumentItem.Where(r => r.AssetUniqueIdentificationId == AUIId).FirstOrDefault();
                if (first == null)
                {
                    return true;
                }
                return false;
            }
        }

    }
}