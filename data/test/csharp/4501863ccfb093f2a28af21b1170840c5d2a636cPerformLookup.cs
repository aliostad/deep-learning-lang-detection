using System;
using System.Collections.Generic;
using MCO.Data.WebDispatchPerformance.Models;

namespace MCO.Services.WebDispatchPerformance
{
    using Interfaces;
    using MCO.Data.WebDispatchPerformance.Interfaces;

    public class PerformLookup : IPerformLookup
    {
        #region Initialization
        private readonly IRepository oracleRepository;
        private IEnumerable<DispatchDetails> dispatchDetails;
        private IEnumerable<ReturnDetails> returnDetails;


        public PerformLookup(IRepository oracleRepository, IEnumerable<DispatchDetails> dispatchDetails, IEnumerable<ReturnDetails> returnDetails)
        {
            this.dispatchDetails = dispatchDetails;
            this.returnDetails = returnDetails;
            this.oracleRepository = oracleRepository;
        }
        #endregion

        #region Main Classes
        public IEnumerable<DispatchDetails> GetLastWeeksDispatchDetail()
        {
            dispatchDetails = oracleRepository.GetLastWeekWebDispatchDetails();
            return dispatchDetails;
        }

        public IEnumerable<ReturnDetails> GetLastWeeksReturnsDetail()
        {
            returnDetails = oracleRepository.GetLastWeekWebReturnDetails();
            return returnDetails;
        }
        #endregion

        #region functions

        #endregion
    }
}