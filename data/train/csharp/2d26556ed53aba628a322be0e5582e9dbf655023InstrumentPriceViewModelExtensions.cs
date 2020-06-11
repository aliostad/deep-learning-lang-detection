namespace Instrument.Ui.ViewModels
{
    public static class InstrumentPriceViewModelExtensions
    {
        public static void Update(this InstrumentPriceViewModel viewModel, AggregatedInstrumentPrice price)
        {
            viewModel.CurrentPrice.Update(price.CurrentPrice);
            viewModel.AveragePrice.Update(price.AveragePrice);
        }

        public static InstrumentPriceViewModel ToViewModel(this AggregatedInstrumentPrice price)
        {
            return new InstrumentPriceViewModel
            {
                Instrument = price.Instrument,
                CurrentPrice = new PriceViewModel
                {
                    Value = price.CurrentPrice
                },
                AveragePrice = new PriceViewModel
                {
                    Value = price.AveragePrice
                }
            };
        }
    }
}
