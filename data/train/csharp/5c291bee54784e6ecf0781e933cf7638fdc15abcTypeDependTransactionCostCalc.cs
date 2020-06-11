using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Funds.Domain
{
    class TypeDependTransactionCostCalc : ITransactionCostCalc
    {
        public decimal Calculate(FinancialInstrument instrument)
        {
            if(instrument == null)
            {
                throw new ArgumentNullException();
            }
            else if(instrument is Bond)
            {
                return instrument.MarketValue * 0.02m;
            }
            else if (instrument is Equity)
            {
                return instrument.MarketValue * 0.005m;
            }
            else
            {
                return 0;
            }
            
        }
    }
}
