//using System;
//using GalaSoft.MvvmLight;
//using LoonieTrader.Shared.Models;

//namespace LoonieTrader.Library.ViewModels
//{
//    public abstract class ChartBaseViewModel: ViewModelBase
//    {
//        private InstrumentViewModel _instrument;
//        public InstrumentViewModel Instrument
//        {
//            get { return _instrument; }
//            set
//            {
//                if (_instrument != value)
//                {
//                    _instrument = value;
//                    RaisePropertyChanged();
//                }
//            }
//        }

//        public void AddIndicator(Func<OhlciPoint, double> func)
//        {
//        }
//    }
//}