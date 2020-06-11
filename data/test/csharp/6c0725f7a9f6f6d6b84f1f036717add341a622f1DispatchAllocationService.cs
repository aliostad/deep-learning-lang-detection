

using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using Cats.Data.Hub.UnitWork;
using Cats.Data.Hub.UnitWork;
using Cats.Models.Hubs;
using Cats.Models.Hubs.ViewModels;
using Cats.Models.Hubs.ViewModels.Common;
using Cats.Models.Hubs.ViewModels.Dispatch;


namespace Cats.Services.Hub
{

    public class DispatchAllocationService : IDispatchAllocationService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IShippingInstructionService _shippingInstructionService;


        public DispatchAllocationService(IUnitOfWork unitOfWork, IShippingInstructionService shippingInstructionService)
        {
            this._unitOfWork = unitOfWork;
            this._shippingInstructionService = shippingInstructionService;
        }

        #region Default Service Implementation

        public bool AddDispatchAllocation(DispatchAllocation dispatchAllocation)
        {
            _unitOfWork.DispatchAllocationRepository.Add(dispatchAllocation);
            _unitOfWork.Save();
            return true;

        }

        public bool EditDispatchAllocation(DispatchAllocation dispatchAllocation)
        {
            _unitOfWork.DispatchAllocationRepository.Edit(dispatchAllocation);
            _unitOfWork.Save();
            return true;

        }

        public bool DeleteDispatchAllocation(DispatchAllocation dispatchAllocation)
        {
            if (dispatchAllocation == null) return false;
            _unitOfWork.DispatchAllocationRepository.Delete(dispatchAllocation);
            _unitOfWork.Save();
            return true;
        }

        public bool DeleteById(int id)
        {
            var entity = _unitOfWork.DispatchAllocationRepository.FindById(id);
            if (entity == null) return false;
            _unitOfWork.DispatchAllocationRepository.Delete(entity);
            _unitOfWork.Save();
            return true;
        }

        public List<DispatchAllocation> GetAllDispatchAllocation()
        {
            return _unitOfWork.DispatchAllocationRepository.GetAll();
        }

        public DispatchAllocation FindById(int id)
        {
            return _unitOfWork.DispatchAllocationRepository.FindById(id);
        }

        public DispatchAllocation FindById(System.Guid id)
        {
            return _unitOfWork.DispatchAllocationRepository.Get(t => t.DispatchAllocationID == id).FirstOrDefault();

        }

        public List<DispatchAllocation> FindBy(Expression<Func<DispatchAllocation, bool>> predicate)
        {
            return _unitOfWork.DispatchAllocationRepository.FindBy(predicate);
        }

        #endregion

        /// <summary>
        /// Gets the balance of an SI number commodity .
        /// </summary>
        /// <param name="siNumber">The si number.</param>
        /// <param name="commodityId">The commodity id.</param>
        /// <param name="hubId">The hub id.</param>
        /// <returns></returns>
        public decimal GetUncommitedBalance(int siNumber, int commodityId, int hubId)
        {
            var total = (from tr in _unitOfWork.TransactionRepository.GetAll()
                         where tr.LedgerID == Cats.Models.Ledger.Constants.GOODS_ON_HAND_UNCOMMITED
                               && tr.ShippingInstructionID == siNumber &&
                               (tr.CommodityID == commodityId || tr.ParentCommodityID == commodityId) &&
                               tr.HubID == hubId
                         select tr.QuantityInMT);
            if (total.Any())
            {
                return total.Sum();
            }
            return 0;
        }

        /// <summary>
        /// Gets the list of dispatch allocations uncommited allocations by hub.
        /// </summary>
        /// <param name="hubId">The hub id.</param>
        /// <returns></returns>
        public List<DispatchAllocation> GetUncommitedAllocationsByHub(int hubId)
        {
            return
                _unitOfWork.DispatchAllocationRepository.Get(
                    p => p.HubID == hubId && !p.ShippingInstructionID.HasValue && !p.ProjectCodeID.HasValue, null,
                    "FDP,FDP.AdminUnit,FDP.AdminUnit.AdminUnit2").ToList();
        }

        /// <summary>
        /// Gets the list of uncommited uncomited allocations.
        /// </summary>
        /// <param name="ids">The ids.</param>
        /// <returns></returns>
        public List<DispatchAllocation> GetUncomitedAllocations(Guid[] ids)
        {
            return _unitOfWork.DispatchAllocationRepository.Get(p => ids.Contains(p.DispatchAllocationID)).ToList();
        }

        /// <summary>
        /// Gets the allocations.
        /// </summary>
        /// <param name="RequisitionNo">The requisition no.</param>
        /// <param name="CommodityID">The commodity ID.</param>
        /// <param name="hubId">The hub id.</param>
        /// <param name="UnComitted">if set to <c>true</c> [un comitted].</param>
        /// <returns></returns>
        public List<DispatchAllocation> GetAllocations(string RequisitionNo, int CommodityID, int hubId, bool UnComitted,
                                                       string PreferedWeightMeasurment)
        {
            var list =
                _unitOfWork.DispatchAllocationRepository.Get(p => p.RequisitionNo == RequisitionNo && p.HubID == hubId
                                                                  && p.CommodityID == CommodityID);
            if (UnComitted)
            {
                list = list.Where(p => !p.ShippingInstructionID.HasValue && !p.ProjectCodeID.HasValue);
            }
            foreach (var dispatchAllocation in list)
            {
                //dispatchAllocation.AmontInUnit = dispatchAllocation.Amount;TODO if we were 
                if (PreferedWeightMeasurment.ToUpperInvariant() == "MT" &&
                    dispatchAllocation.Commodity.CommodityTypeID == 1)
                {
                    dispatchAllocation.Amount /= 10;
                }
            }

            return list.ToList();
        }

        /// <summary>
        /// Gets the allocations.
        /// </summary>
        /// <param name="RequisitionNo">The requisition no.</param>
        /// <param name="hubId">The hub id.</param>
        /// <param name="UnComitted">if set to <c>true</c> [un comitted].</param>
        /// <returns></returns>
        public List<DispatchAllocation> GetAllocations(string RequisitionNo, int hubId, bool UnComitted)
        {
            var list =
                _unitOfWork.DispatchAllocationRepository.Get(p => p.RequisitionNo == RequisitionNo && p.HubID == hubId);
            if (UnComitted)
            {
                list = list.Where(p => !p.ShippingInstructionID.HasValue && !p.ProjectCodeID.HasValue);
            }
            return list.ToList();
        }

        /// <summary>
        /// Gets the available SI numbers in a given hub
        /// </summary>
        /// <param name="commodityID">The commodity ID.</param>
        /// <param name="hubID"> </param>
        /// <returns></returns>
        public List<ShippingInstruction> GetAvailableSINumbersWithUncommitedBalance(int commodityID, int hubID)
        {
            var tempTransactions =
                _unitOfWork.TransactionRepository.Get(
                    t => (t.CommodityID == commodityID || t.ParentCommodityID == commodityID)
                         && t.LedgerID == Cats.Models.Ledger.Constants.GOODS_ON_HAND_UNCOMMITED
                         && t.HubID == hubID);
            var SIs = (from tr in tempTransactions
                       group tr by new {tr.ShippingInstruction}
                       into si
                       select
                           new
                               {
                                   SI = si.Key.ShippingInstruction,
                                   AvailableBalance = si.Sum(p => p.QuantityInMT),
                                   AvailableBalanceInUnit = si.Sum(q => q.QuantityInUnit)
                               });

            return (from si in SIs
                    where si.AvailableBalance > 0 || si.AvailableBalanceInUnit > 0
                    select si.SI).ToList();
        }

        /// <summary>
        /// Gets the uncommited allocation transaction.
        /// </summary>
        /// <param name="commodityID">The commodity ID.</param>
        /// <param name="shipingInstructionID">The shiping instruction ID.</param>
        /// <param name="hubID">The hub ID.</param>
        /// <returns></returns>
        public Transaction GetUncommitedAllocationTransaction(int commodityID, int shipingInstructionID, int hubID)
        {
            return
                _unitOfWork.TransactionRepository.Get(
                    tr =>
                    (tr.CommodityID == commodityID || tr.ParentCommodityID == commodityID) &&
                    tr.LedgerID == Cats.Models.Ledger.Constants.GOODS_ON_HAND_UNCOMMITED
                    && tr.ShippingInstructionID == shipingInstructionID && tr.HubID == hubID).
                    FirstOrDefault();

        }

        /// <summary>
        /// Gets the available commodities.
        /// </summary>
        /// <param name="requisitionNo">The requisition no.</param>
        /// <returns></returns>
        public List<Commodity> GetAvailableCommodities(string requisitionNo)
        {
            var tempDispatchAllocation =
                _unitOfWork.DispatchAllocationRepository.Get(t => t.RequisitionNo == requisitionNo);
            return (from tr in tempDispatchAllocation
                    select tr.Commodity).Distinct().ToList();
        }

        /// <summary>
        /// Attaches the transaction group.
        /// </summary>
        /// <param name="allocation">The allocation.</param>
        /// <param name="TransactionGroupID">The transaction group ID.</param>
        /// <returns></returns>
        public bool AttachTransactionGroup(DispatchAllocation allocation, int TransactionGroupID)
        {
            DispatchAllocation original =
                _unitOfWork.DispatchAllocationRepository.Get(
                    p => p.DispatchAllocationID == allocation.DispatchAllocationID).SingleOrDefault();
            if (original != null)
            {
                //original.TransactionGroupID = TransactionGroupID;
                _unitOfWork.Save();
                return true;
            }
            return false;

        }

        /// <summary>
        /// Gets the SI balances.
        /// </summary>
        /// <returns></returns>
        public List<SIBalance> GetSIBalances(int hubID)
        {
            var tempTransactions =
                _unitOfWork.TransactionRepository.Get(
                    t => t.LedgerID == Cats.Models.Ledger.Constants.GOODS_ON_HAND_UNCOMMITED && t.HubID == hubID);
            var list = (from ls in tempTransactions
                        group ls by new {ls.ShippingInstruction, ls.ProjectCode, ls.Commodity, ls.Program}
                        into si
                        select new SIBalance()
                                   {
                                       SINumber = si.Key.ShippingInstruction.Value,
                                       AvailableBalance = si.Sum(p => p.QuantityInMT),
                                       Commodity = si.Key.Commodity.Name,
                                       Project = si.Key.ProjectCode.Value,
                                       Program = si.Key.Program.Name,
                                       SINumberID = si.Key.ShippingInstruction.ShippingInstructionID,
                                       ProjectCodeID = si.Key.ProjectCode.ProjectCodeID
                                   }).ToList();

            return list;
        }

        /// <summary>
        /// Gets the SI balances grouped by commodity.
        /// </summary>
        /// <returns></returns>
        public List<CommodityBalance> GetSIBalancesGroupedByCommodity(int hubID)
        {
            var list = (from ls in GetSIBalances(hubID)
                        group ls by new {ls.Commodity}
                        into si
                        select new CommodityBalance()
                                   {
                                       Commodity = si.Key.Commodity,
                                       Balances = si.ToList()

                                   }).ToList();

            return list;
        }



        public bool CommitDispatchAllocation(Guid AllocationId, int SIID, int ProjectCodeID)
        {
            DispatchAllocation all =
                _unitOfWork.DispatchAllocationRepository.Get(p => p.DispatchAllocationID == AllocationId).
                    SingleOrDefault();
            if (all != null)
            {
                all.ShippingInstructionID = SIID;
                all.ProjectCodeID = ProjectCodeID;
                _unitOfWork.Save();
                return true;
            }
            return false;
        }

        /// <summary>
        /// Gets the commited allocations by hub.
        /// </summary>
        /// <param name="hubId">The hub id.</param>
        /// <returns></returns>
        public List<DispatchAllocation> GetCommitedAllocationsByHub(int hubId)
        {
            return
                _unitOfWork.DispatchAllocationRepository.Get(
                    p => p.HubID == hubId && p.ShippingInstructionID.HasValue && p.ProjectCodeID.HasValue).ToList();
        }

        public List<DispatchAllocationViewModelDto> GetCommitedAllocationsByHubDetached(int hubId,
                                                                                        string PreferedWeightMeasurment,
                                                                                        bool? closedToo,
                                                                                        int? AdminUnitId,
                                                                                        int? CommodityType)
        {
            List<DispatchAllocationViewModelDto> GetUncloDetacheced = new List<DispatchAllocationViewModelDto>();
            //TODO:Check whether both si and pc is required for checking
            var unclosed =
                _unitOfWork.DispatchAllocationRepository.Get(
                    t => (t.ShippingInstructionID.HasValue || t.ProjectCodeID.HasValue)
                         && hubId == t.HubID
                    );


            if (AdminUnitId.HasValue)
            {
                AdminUnit adminunit = _unitOfWork.AdminUnitRepository.FindById(AdminUnitId.Value);

                if (adminunit.AdminUnitType.AdminUnitTypeID == 2) //by region
                    unclosed =
                        unclosed.Where(p => p.FDP.AdminUnit.AdminUnit2.AdminUnit2.AdminUnitID == AdminUnitId.Value);
                else if (adminunit.AdminUnitType.AdminUnitTypeID == 3) //by zone
                    unclosed =
                        unclosed.Where(p => p.FDP.AdminUnit.AdminUnit2.AdminUnitID == AdminUnitId.Value);
                else if (adminunit.AdminUnitType.AdminUnitTypeID == 4) //by woreda
                    unclosed =
                        unclosed.Where(p => p.FDP.AdminUnitID == AdminUnitId.Value);
                //DAVMD.Region = adminunit.FDP.AdminUnit.AdminUnit2.AdminUnit2.;
                //DAVMD.Zone = adminunit.FDP.AdminUnit.AdminUnit2.Name;
                //DAVMD.Woreda = adminunit.FDP.AdminUnit.Name;

                //unclosed = unclosed.Where(p => p.FDP.AdminUnitID == AdminUnitId.Value);
            }
            if (closedToo == null || closedToo == false)
            {
                unclosed = unclosed.Where(p => p.IsClosed == false);
            }
            else
            {
                unclosed = unclosed.Where(p => p.IsClosed == true);
            }

            if (CommodityType.HasValue)
            {
                unclosed = unclosed.Where(p => p.Commodity.CommodityTypeID == CommodityType.Value);
            }
            else
            {
                unclosed = unclosed.Where(p => p.Commodity.CommodityTypeID == 1); //by default
            }

            foreach (var dispatchAllocation in unclosed)
            {
                var DAVMD = new DispatchAllocationViewModelDto();
                if (PreferedWeightMeasurment.ToUpperInvariant() == "MT " &&
                    dispatchAllocation.Commodity.CommodityTypeID == 1) //only for food
                {
                    DAVMD.Amount = dispatchAllocation.Amount;
                    DAVMD.DispatchedAmount = dispatchAllocation.DispatchedAmount;
                    DAVMD.RemainingQuantityInQuintals = dispatchAllocation.RemainingQuantityInQuintals;
                }
                else
                {
                    DAVMD.Amount = dispatchAllocation.Amount*10;
                    DAVMD.DispatchedAmount = dispatchAllocation.DispatchedAmount*10;
                    DAVMD.RemainingQuantityInQuintals = dispatchAllocation.RemainingQuantityInQuintals*10;
                }
                DAVMD.DispatchAllocationID = dispatchAllocation.DispatchAllocationID;
                DAVMD.CommodityName = dispatchAllocation.Commodity.Name;
                DAVMD.RequisitionNo = dispatchAllocation.RequisitionNo;
                DAVMD.BidRefNo = dispatchAllocation.BidRefNo;

                DAVMD.Region = dispatchAllocation.FDP.AdminUnit.AdminUnit2.AdminUnit2.Name;
                DAVMD.Zone = dispatchAllocation.FDP.AdminUnit.AdminUnit2.Name;
                DAVMD.Woreda = dispatchAllocation.FDP.AdminUnit.Name;
                DAVMD.FDPName = dispatchAllocation.FDP.Name;
                DAVMD.IsClosed = dispatchAllocation.IsClosed;
                if (dispatchAllocation.Transporter != null) DAVMD.TransporterName = dispatchAllocation.Transporter.Name;
                DAVMD.Round = (dispatchAllocation.Round==null)?"-":dispatchAllocation.Round.ToString();
              
               
               


                DAVMD.AmountInUnit = DAVMD.Amount;
                DAVMD.DispatchedAmountInUnit = dispatchAllocation.DispatchedAmountInUnit;
                DAVMD.RemainingQuantityInUnit = dispatchAllocation.RemainingQuantityInUnit;

                GetUncloDetacheced.Add(DAVMD);
                // db.Detach(dispatchAllocation);
            }
            return GetUncloDetacheced;

        }

        public List<DispatchAllocationViewModelDto> GetCommitedAllocationsByHubDetached(int hubId,
                                                                                        string PreferedWeightMeasurment)
        {
            List<DispatchAllocationViewModelDto> GetUncloDetacheced = new List<DispatchAllocationViewModelDto>();
            var unclosed =
                _unitOfWork.DispatchAllocationRepository.Get(
                    t => t.ShippingInstructionID.HasValue && t.ProjectCodeID.HasValue
                         && hubId == t.HubID);


            //if (AdminUnitId.HasValue)
            //{
            //    AdminUnit adminunit = _unitOfWork.AdminUnitRepository.FindById(AdminUnitId.Value);

            //    if (adminunit.AdminUnitType.AdminUnitTypeID == 2)//by region
            //        unclosed =
            //            unclosed.Where(p => p.FDP.AdminUnit.AdminUnit2.AdminUnit2.AdminUnitID == AdminUnitId.Value);
            //    else if (adminunit.AdminUnitType.AdminUnitTypeID == 3)//by zone
            //        unclosed =
            //                unclosed.Where(p => p.FDP.AdminUnit.AdminUnit2.AdminUnitID == AdminUnitId.Value);
            //    else if (adminunit.AdminUnitType.AdminUnitTypeID == 4)//by woreda
            //        unclosed =
            //                unclosed.Where(p => p.FDP.AdminUnit.AdminUnitID == AdminUnitId.Value);
            //    //DAVMD.Region = adminunit.FDP.AdminUnit.AdminUnit2.AdminUnit2.;
            //    //DAVMD.Zone = adminunit.FDP.AdminUnit.AdminUnit2.Name;
            //    //DAVMD.Woreda = adminunit.FDP.AdminUnit.Name;

            //    //unclosed = unclosed.Where(p => p.FDP.AdminUnitID == AdminUnitId.Value);
            //}
            //if (closedToo == null || closedToo == false)
            //{
            //    unclosed = unclosed.Where(p => p.IsClosed == false);
            //}
            //else
            //{
            //    unclosed = unclosed.Where(p => p.IsClosed == true);
            //}

            //if (CommodityType.HasValue)
            //{
            //    unclosed = unclosed.Where(p => p.Commodity.CommodityTypeID == CommodityType.Value);
            //}
            //else
            //{
            //    unclosed = unclosed.Where(p => p.Commodity.CommodityTypeID == 1);//by default
            //}

            foreach (var dispatchAllocation in unclosed)
            {
                var DAVMD = new DispatchAllocationViewModelDto();
                if (PreferedWeightMeasurment.ToUpperInvariant() == "MT" &&
                    dispatchAllocation.Commodity.CommodityTypeID == 1) //only for food
                {
                    DAVMD.Amount = dispatchAllocation.Amount/10;
                    DAVMD.DispatchedAmount = dispatchAllocation.DispatchedAmount/10;
                    DAVMD.RemainingQuantityInQuintals = dispatchAllocation.RemainingQuantityInQuintals/10;
                }
                else
                {
                    DAVMD.Amount = dispatchAllocation.Amount;
                    DAVMD.DispatchedAmount = dispatchAllocation.DispatchedAmount;
                    DAVMD.RemainingQuantityInQuintals = dispatchAllocation.RemainingQuantityInQuintals;
                }
                DAVMD.DispatchAllocationID = dispatchAllocation.DispatchAllocationID;
                DAVMD.CommodityName = dispatchAllocation.Commodity.Name;
                DAVMD.RequisitionNo = dispatchAllocation.RequisitionNo;
                DAVMD.BidRefNo = dispatchAllocation.BidRefNo;

                DAVMD.Region = dispatchAllocation.FDP.AdminUnit.AdminUnit2.AdminUnit2.Name;
                DAVMD.Zone = dispatchAllocation.FDP.AdminUnit.AdminUnit2.Name;
                DAVMD.Woreda = dispatchAllocation.FDP.AdminUnit.Name;
                DAVMD.FDPName = dispatchAllocation.FDP.Name;
                DAVMD.IsClosed = dispatchAllocation.IsClosed;


                DAVMD.AmountInUnit = DAVMD.Amount;
                DAVMD.DispatchedAmountInUnit = dispatchAllocation.DispatchedAmountInUnit;
                DAVMD.RemainingQuantityInUnit = dispatchAllocation.RemainingQuantityInUnit;

                GetUncloDetacheced.Add(DAVMD);
                // db.Detach(dispatchAllocation);
            }
            return GetUncloDetacheced;

        }


        public List<BidRefViewModel> GetAllBidRefsForReport()
        {
            var tempDispatchAllocations = _unitOfWork.DispatchAllocationRepository.Get(t => t.BidRefNo != string.Empty);
            var BidRefs = (from b in tempDispatchAllocations
                           select
                               new BidRefViewModel() {BidRefId = b.BidRefNo, BidRefText = b.BidRefNo})
                .Distinct().ToList();
            return BidRefs;
        }

        /// <summary>
        /// Gets the available requision numbers.
        /// </summary>
        /// <param name="HubId">The hub id.</param>
        /// <param name="UnCommited">if set to <c>true</c> [un commited].</param>
        /// <returns></returns>
        public List<string> GetAvailableRequisionNumbers(int HubId, bool UnCommited)
        {
            var allocations = _unitOfWork.DispatchAllocationRepository.Get(t => t.HubID == HubId);

            if (UnCommited)
            {
                allocations =
                    allocations.Where(p => !(p.ShippingInstructionID.HasValue || p.ProjectCodeID.HasValue)).ToList();
            }

            return allocations.Select(p => p.RequisitionNo).Distinct().ToList();

        }


        /// <summary>
        /// Gets the allocations under a given requisition number.
        /// </summary>
        /// <param name="requisitonNumber">The requisiton number.</param>
        /// <returns></returns>
        public List<DispatchAllocation> GetAllocations(string requisitonNumber)
        {
            return _unitOfWork.DispatchAllocationRepository.FindBy(t => t.RequisitionNo == requisitonNumber);


        }


        /// <summary>
        /// Commits the dispatch allocation.
        /// </summary>
        /// <param name="checkedRecords">The checked records.</param>
        /// <param name="SINumber">The SI number.</param>
        /// <param name="user">The user.</param>
        /// <param name="ProjectCode">The project code.</param>
        public void CommitDispatchAllocation(string[] checkedRecords, int SINumber, UserProfile user, int ProjectCode)
        {
            foreach (var checkedRecord in checkedRecords)
            {
                CommitDispatchAllocation(Guid.Parse(checkedRecord), SINumber, ProjectCode);
            }

        }


        public List<RequisitionSummary> GetSummaryForUncommitedAllocations(int hubId)
        {
            var tempDispatchAllocations =
                _unitOfWork.DispatchAllocationRepository.Get(
                    t => t.IsClosed == false && t.ProgramID == null && t.Year == null);
            var UnCommitedDispatches = (from v in tempDispatchAllocations
                                        select
                                            new RequisitionSummary
                                                {
                                                    CommodityName = v.Commodity.Name,
                                                    Region = v.FDP.AdminUnit.AdminUnit2.AdminUnit2.Name,
                                                    RequistionNo = v.RequisitionNo,
                                                    Status = "Not Commited",
                                                    Zone = v.FDP.AdminUnit.AdminUnit2.Name
                                                }
                                       ).Distinct().ToList();
            return UnCommitedDispatches;
        }

        public List<RequisitionSummary> GetSummaryForCommitedAllocations(int hubId)
        {
            var tempDispatchAllocations =
                _unitOfWork.DispatchAllocationRepository.Get(
                    t => t.IsClosed != false && t.ProgramID != null && t.Year != null);
            var CommitedDispatches = (from v in tempDispatchAllocations
                                      select
                                          new RequisitionSummary
                                              {
                                                  CommodityName = v.Commodity.Name,
                                                  Region = v.FDP.AdminUnit.AdminUnit2.AdminUnit2.Name,
                                                  RequistionNo = v.RequisitionNo,
                                                  Status = "Not Commited",
                                                  Zone = v.FDP.AdminUnit.AdminUnit2.Name
                                              }
                                     ).Distinct().ToList();
            return CommitedDispatches;
        }


        /// <summary>
        /// Gets the uncommited SI balance.
        /// </summary>
        /// <param name="hubID">The hub ID.</param>
        /// <param name="commodityId">The commodity id.</param>
        /// <returns></returns>
        public List<SIBalance> GetUncommitedSIBalance(int hubID, int commodityId, string PreferedWeightMeasurment)
        {
            var sis = _shippingInstructionService.GetShippingInstructionsWithBalance(hubID, commodityId);
            var com = _unitOfWork.CommodityRepository.FindById(commodityId);
            bool IsFood = com.CommodityTypeID == 1;
            List<SIBalance> result = new List<SIBalance>();
            List<SIBalance> positiveresult = new List<SIBalance>();
            foreach (var si in sis)
            {
                SIBalance balance = null;

                if (IsFood)
                    balance = _shippingInstructionService.GetBalance(hubID, commodityId,
                                                                     si.ShippingInstructionID);
                else
                    balance = _shippingInstructionService.GetBalanceInUnit(hubID, commodityId,
                                                                           si.ShippingInstructionID);
                //if (balance.Dispatchable > 0)//buggy if the in store balance is less than 0 it will be replaced by the data by receipt allocation data
                if (balance != null)
                    result.Add(balance);
            }


            //From the receipt allocation
            List<SIBalance> SIfromReceipts = new List<SIBalance>();
            //TODO:When ReceiptAllcationService is implemented return and fix this part
            //if (IsFood)
            //    SIfromReceipts = repository.ReceiptAllocation.GetSIBalanceForCommodity(hubID, commodityId);
            //else
            //    SIfromReceipts = repository.ReceiptAllocation.GetSIBalanceForCommodityInUnit(hubID, commodityId);

            foreach (var sIfromReceipt in SIfromReceipts)
            {
                if (!result.Any(p => p.SINumber == sIfromReceipt.SINumber) && sIfromReceipt.Dispatchable > 0)
                {
                    result.Add(sIfromReceipt);
                }
            }
            foreach (SIBalance siBalanceList in result)
            {
                if (siBalanceList.Dispatchable > 0)
                {
                    if (PreferedWeightMeasurment.ToUpperInvariant() == "QN" && (IsFood))
                    {
                        siBalanceList.AvailableBalance *= 10;
                        siBalanceList.TotalDispatchable *= 10;
                        siBalanceList.Dispatchable *= 10;
                        siBalanceList.ReaminingExpectedReceipts *= 10;
                    }
                    positiveresult.Add(siBalanceList);
                }
            }
            //foreach (var si in sis) {

            //var rAll  = repository.ReceiptAllocation.FindBySINumber(si.Value)
            //    .Where(
            //    p =>
            //    {
            //        if (p.Commodity.ParentID == null)
            //            return p.CommodityID == commodityId;
            //        else
            //            return p.Commodity.ParentID == commodityId;
            //    }
            //    )
            //    .Where(q=>q.IsClosed == false).Select( new SIBalance
            //                                               {
            //                                                   AvailableBalance = 
            //                                               });

            //}

            //foreach (var si in sis)
            //{
            //    if (si != null)
            //    {
            //        repository.ReceiptAllocation.GetAll().Where(
            //            p => p.SINumber == si.Value && p.CommodityID == commodityId);

            //    }
            //}

            return positiveresult;
        }


        public void CloseById(Guid id)
        {
            var delAllocation =
                _unitOfWork.DispatchAllocationRepository.Get(allocation => allocation.DispatchAllocationID == id).
                    FirstOrDefault();
            if (delAllocation != null)
                delAllocation.IsClosed = true;
            _unitOfWork.Save();
        }

        public void Dispose()
        {
            _unitOfWork.Dispose();

        }



        public IEnumerable<DispatchAllocation> Get(Expression<Func<DispatchAllocation, bool>> filter = null,
                                                   Func
                                                       <IQueryable<DispatchAllocation>,
                                                       IOrderedQueryable<DispatchAllocation>> orderBy = null,
                                                   string includeProperties = "")
        {
            return _unitOfWork.DispatchAllocationRepository.Get(filter, null, includeProperties);
        }


        public List<DispatchViewModel> GetTransportOrderDispatches(int transportOrderId)
        {
            //Get List of dispatch allocation with passed transporterId
            var dispatchAllocationIds =
                _unitOfWork.DispatchAllocationRepository.Get(t => t.TransportOrderID == transportOrderId).Select(
                    t => t.DispatchAllocationID).ToList();
            var dispatches =
                _unitOfWork.DispatchRepository.Get(t => dispatchAllocationIds.Contains(t.DispatchAllocationID.Value),
                                                   null,
                                                   "DispatchDetails,FDP,FDP.AdminUnit,FDP.AdminUnit.AdminUnit2.AdminUnit2,FDP.AdminUnit.AdminUnit2")
                    .ToList();

            var dispatchViewModels = MapDispatchToDispatchViewModel(dispatches);
            return dispatchViewModels;
        }

        private List<DispatchViewModel> MapDispatchToDispatchViewModel(List<Dispatch> dispatches)
        {
            List<DispatchViewModel> dispatchViewModels = new List<DispatchViewModel>();
            foreach (var dispatch in dispatches)
            {
                var id1 = dispatch.DispatchAllocationID.Value;
                var dispatchAllocation =
                    _unitOfWork.DispatchAllocationRepository.Get(t => t.DispatchAllocationID == id1, null, "Program").
                        FirstOrDefault();

                var dispatchViewModel = new DispatchViewModel();
                dispatchViewModel.BidNumber = dispatch.BidNumber;
                dispatchViewModel.CreatedDate = dispatch.CreatedDate;

                dispatchViewModel.DispatchAllocationID = dispatch.DispatchAllocationID.Value;
                dispatchViewModel.DispatchDate = dispatch.DispatchDate;
                dispatchViewModel.DispatchID = dispatch.DispatchID;
                dispatchViewModel.DispatchedByStoreMan = dispatch.DispatchedByStoreMan;
                dispatchViewModel.DriverName = dispatch.DriverName;
                if (dispatch.FDPID.HasValue)
                    dispatchViewModel.FDPID = dispatch.FDPID.Value;
                dispatchViewModel.FDP = dispatch.FDP.Name;
                dispatchViewModel.Region = dispatch.FDP.AdminUnit.AdminUnit2.AdminUnit2.Name;
                dispatchViewModel.Zone = dispatch.FDP.AdminUnit.AdminUnit2.Name;
                dispatchViewModel.Woreda = dispatch.FDP.AdminUnit.Name;
                dispatchViewModel.GIN = dispatch.GIN;
                dispatchViewModel.HubID = dispatch.HubID;
                // dispatch.ProgramID = dispatchAllocation.ProgramID;
                dispatchViewModel.Program = dispatchAllocation.Program.Name;

                dispatchViewModel.Month = dispatch.PeriodMonth;

                dispatchViewModel.Year = dispatch.PeriodYear;
                dispatchViewModel.PlateNo_Prime = dispatch.PlateNo_Prime;
                dispatchViewModel.PlateNo_Trailer = dispatch.PlateNo_Trailer;
                dispatchViewModel.Remark = dispatch.Remark;
                dispatchViewModel.RequisitionNo = dispatch.RequisitionNo;
                dispatchViewModel.ProgramID = dispatchAllocation.ProgramID.HasValue
                                                  ? dispatchAllocation.ProgramID.Value
                                                  : 0;

                dispatchViewModel.Round = dispatch.Round;

                dispatchViewModel.TransporterID = dispatch.TransporterID;

                dispatchViewModel.WeighBridgeTicketNumber = dispatch.WeighBridgeTicketNumber;

                var dispatchDetail = dispatch.DispatchDetails.FirstOrDefault();
                dispatchViewModel.CommodityID = dispatchDetail.CommodityID;
                dispatchViewModel.Commodity = dispatchDetail.Commodity.Name;
                //dispatch.DispatchDetailID = Guid.NewGuid();
                dispatchViewModel.DispatchID = dispatchDetail.DispatchID;
                dispatchViewModel.Quantity = dispatchDetail.RequestedQuantityInMT;
                dispatchViewModel.QuantityInUnit = dispatchDetail.RequestedQunatityInUnit;
                dispatchViewModel.UnitID = dispatchDetail.UnitID;
                dispatchViewModel.ShippingInstructionID = dispatchAllocation.ShippingInstructionID;
                dispatchViewModel.ProjectCodeID = dispatchAllocation.ProjectCodeID;


                dispatchViewModels.Add(dispatchViewModel);

            }
            return dispatchViewModels;
        }

        public List<DispatchViewModel> GetAllTransportersWithoutGrn()
        {
            var dispatchAllocationIds =
                _unitOfWork.DispatchAllocationRepository.GetAll().Select(t => t.DispatchAllocationID).ToList();
            var dispatches =
                _unitOfWork.DispatchRepository.Get(t => dispatchAllocationIds.Contains(t.DispatchAllocationID.Value),
                                                   null, "DispatchDetails")
                    .ToList();

            List<DispatchViewModel> dispatchViewModels = new List<DispatchViewModel>();
            foreach (var dispatch in dispatches)
            {
                var dispatchViewModel = new DispatchViewModel();
                dispatchViewModel.DispatchID = dispatch.DispatchID;
                dispatchViewModel.DispatchDate = dispatch.DispatchDate;
                dispatchViewModel.Transporter = dispatch.Transporter.Name;
                dispatchViewModel.BidNumber = dispatch.BidNumber;
                dispatchViewModel.FDP = dispatch.FDP.Name;
                dispatchViewModels.Add(dispatchViewModel);
            }
            return dispatchViewModels;
        }
      public  List<int?> GetDispatchedTransportOrders()
        {

            var dispatchAllocationIDs = _unitOfWork.DispatchRepository.GetAll().Select(m => m.DispatchAllocationID).ToList();
           
            var transportOrderID =
                _unitOfWork.DispatchAllocationRepository.FindBy(
                    m => dispatchAllocationIDs.Contains(m.DispatchAllocationID)).Select(m => m.TransportOrderID);
          return transportOrderID.ToList();
        }
    }
}


