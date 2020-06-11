namespace FreeQuant.Instruments
{
	public class PortfolioPricer : IPortfolioPricer
	{
		public virtual double Price(Position position)
		{
			switch (position.Side)
			{
				case PositionSide.Long:
					if (position.Instrument.OrderBook.Bid.Count != 0)
						return position.Instrument.OrderBook.GetAvgBidPrice(position.Qty);
					if (position.Instrument.Quote.Bid != 0.0)
						return position.Instrument.Quote.Bid;
					else
						break;
				case PositionSide.Short:
					if (position.Instrument.OrderBook.Ask.Count != 0)
						return position.Instrument.OrderBook.GetAvgAskPrice(position.Qty);
					if (position.Instrument.Quote.Ask != 0.0)
						return position.Instrument.Quote.Ask;
					else
						break;
			}
			return position.Instrument.Price();
		}
	}
}
