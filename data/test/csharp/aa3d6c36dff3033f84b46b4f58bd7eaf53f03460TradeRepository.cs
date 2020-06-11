using System;
using System.Collections.Generic;
using System.Linq;
using Gilgamesh.Entities.Portfolio;

namespace Gilgamesh.DataAccess
{
    public class TradeRepository : Repository<Trade>, ITradeRepository
    {
        public TradeRepository(IDbContext context) : base(context)
        {
            
        }


        public IEnumerable<Trade> GetLiveTradeForFolioAndInstrumentAtDate(int folioId, int instrumentId, DateTime date)
        {
            return Find(t=>t.PortfolioId==folioId && t.Instrument.InstrumentId==instrumentId &&t.Status==Status.Live && t.TradeDate<=date);
        }

        public IEnumerable<int> GetInstrumentsInPortfolio(int portfolioId)
        {
            return Find(t => t.PortfolioId == portfolioId).GroupBy(t => t.Instrument.InstrumentId).Select(g => g.First().Instrument.InstrumentId);
        }
    }
}