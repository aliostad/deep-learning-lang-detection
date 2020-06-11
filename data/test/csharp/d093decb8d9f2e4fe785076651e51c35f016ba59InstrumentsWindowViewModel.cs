using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Reflection;
using System.Windows;
using System.Windows.Input;
using AutoMapper;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using GalaSoft.MvvmLight.Messaging;
using JetBrains.Annotations;
using LoonieTrader.App.MessageTypes;
using LoonieTrader.App.Views;
using LoonieTrader.Library.Constants;
using LoonieTrader.Library.Interfaces;
using LoonieTrader.Library.RestApi.Caches;
using LoonieTrader.Library.RestApi.Interfaces;
using LoonieTrader.Library.RestApi.Responses;
using LoonieTrader.Library.ViewModels;

namespace LoonieTrader.App.ViewModels.Windows
{
    [UsedImplicitly]
    public class InstrumentsWindowViewModel : ViewModelBase
    {
        public InstrumentsWindowViewModel(ISettingsService settingsService, IMapper mapper, IExtendedLogger logger, IAccountsRequester accountsRequester)
        {
            _settingsService = settingsService;
            _logger = logger;
            _settings = settingsService.CachedSettings.SelectedEnvironment;
            _accountsRequester = accountsRequester;

            SelectedInstrumentChangedCommand = new RelayCommand<object>(SelectedInstrumentChanged);
            AddInstrumentToFavouritesContextCommand = new RelayCommand(AddInstrumentToFavourites);
            RemoveInstrumentToFavouritesContextCommand = new RelayCommand(RemoveInstrumentToFavourites);
            OpenInstrumentInMainContextCommand = new RelayCommand(OpenInstrumentInMain);
            OpenInstrumentInNewChartContextCommand = new RelayCommand(OpenInstrumentInNewChart);
            OpenInstrumentInTradeContextCommand = new RelayCommand(OpenInstrumentInTrade);

            if (IsInDesignMode)
            {
            }
            else
            {

                try
                {
                    AccountInstrumentsResponse instrumentsResponse = _accountsRequester.GetAccountInstruments(_settings.DefaultAccountId);
                    InstrumentCache.Instruments = instrumentsResponse.instruments;

                    var allInstruments = mapper.Map<IList<InstrumentViewModel>>(InstrumentCache.Instruments);
                    // todo automapper
                    var groups = allInstruments.Select(x => x).GroupBy(x => x.Type).OrderBy(o => o.Key);
                    List<InstrumentTypeViewModel> its =
                        groups.Select(x => new InstrumentTypeViewModel
                        {
                            Type = x.Key,
                            Instruments = x.OrderBy(o => o.DisplayName).ToList()
                        }).ToList();

                    var favourites = new InstrumentTypeViewModel()
                    {
                        Type = AppProperties.FavouritesFolderName,
                        Instruments = new List<InstrumentViewModel>()
                    };

                    its.Insert(0, favourites);

                    foreach (var fi in _settings.FavouriteInstruments)
                    {
                        var ivm = mapper.Map<InstrumentViewModel>(InstrumentCache.Lookup(fi));
                        if (ivm != null)
                        {
                            favourites.Instruments.Add(ivm);
                        }
                    }

                    _allInstrumentTypes = new ObservableCollection<InstrumentTypeViewModel>(its);

                }
                catch (Exception)
                {
                    MessageBox.Show("Failed to start application", AppProperties.ApplicationName);

//                    throw;
                }

            }
        }

        private readonly IEnvironmentSettings _settings;
        private readonly ISettingsService _settingsService;
        private readonly IExtendedLogger _logger;
        private readonly IAccountsRequester _accountsRequester;

        private readonly ObservableCollection<InstrumentTypeViewModel> _allInstrumentTypes;

        public RelayCommand<object> SelectedInstrumentChangedCommand { get; private set; }
        public ICommand AddInstrumentToFavouritesContextCommand { get; private set; }

        public ICommand RemoveInstrumentToFavouritesContextCommand { get; private set; }

        public ICommand OpenInstrumentInMainContextCommand { get; private set; }

        public ICommand OpenInstrumentInNewChartContextCommand { get; private set; }

        public ICommand OpenInstrumentInTradeContextCommand { get; private set; }

        public ObservableCollection<InstrumentTypeViewModel> AllInstrumentTypes
        {
            get { return _allInstrumentTypes; }
        }

        private InstrumentViewModel _selectedInstrument;

        public InstrumentViewModel SelectedInstrument
        {
            get { return _selectedInstrument; }
            set
            {
                if (_selectedInstrument != value)
                {
                    _selectedInstrument = value;
                    RaisePropertyChanged();
                }
            }
        }

        private void SelectedInstrumentChanged(object o)
        {
            InstrumentViewModel instrument = o as InstrumentViewModel;
            InstrumentTypeViewModel instrumentType = o as InstrumentTypeViewModel;

            _logger.Debug($"{GetType().Name}.{MethodBase.GetCurrentMethod().Name} - {instrumentType?.Type} - {instrument?.DisplayName}");

            if (instrument != null)
            {
                SelectedInstrument = instrument;
 //               Console.WriteLine(instrument.DisplayName);
            }
            if (instrumentType != null)
            {
                SelectedInstrument = null;
   //             Console.WriteLine(instrumentType.Type);
            }
        }

        private void AddInstrumentToFavourites()
        {
            if (SelectedInstrument != null)
            {
                Console.WriteLine(@"Add: {0}", SelectedInstrument);

                var it = AllInstrumentTypes.FirstOrDefault(x => x.Type == AppProperties.FavouritesFolderName);
                if (it != null)
                {
                    bool exists = it.Instruments.Any(x => x.Name == SelectedInstrument.Name);
                    if (!exists)
                    {
                        it.Instruments.Add(SelectedInstrument);

                        it.RaisePropertyChanged(() => it.Instruments);

                        _settingsService.CachedSettings.SelectedEnvironment.FavouriteInstruments.Add(SelectedInstrument.Name);
                        _settingsService.SaveSettings(_settingsService.CachedSettings);
                    }
                }
            }
        }

        private void RemoveInstrumentToFavourites()
        {
            if (SelectedInstrument != null)
            {
                Console.WriteLine(@"Remove: {0}", SelectedInstrument);
            }
        }

        private void OpenInstrumentInMain()
        {
            if (SelectedInstrument != null)
            {
                Console.WriteLine(SelectedInstrument);
                //ChangeChartInstrument(SelectedInstrument);
                Messenger.Default.Send(new ChangeInstrumentMessage(SelectedInstrument));
            }
        }

        private void OpenInstrumentInNewChart()
        {
            if (SelectedInstrument != null)
            {
                Console.WriteLine(SelectedInstrument);
                OpenNewChartWindow(SelectedInstrument);
            }
        }

        private void OpenInstrumentInTrade()
        {
            if (SelectedInstrument != null)
            {
                Console.WriteLine(SelectedInstrument);
                OpenComplexOrderWindow(SelectedInstrument);
            }
        }

        private void OpenComplexOrderWindow(InstrumentViewModel instrument)
        {
            ComplexOrderWindow cow = new ComplexOrderWindow();
            cow.Owner = Application.Current.MainWindow;
            cow.ShowInstrument(instrument);
        }

        private void OpenNewChartWindow(InstrumentViewModel instrument)
        {
            ChartWindow tw = new ChartWindow();
            tw.Owner = Application.Current.MainWindow;
            tw.ShowInstrument(instrument);
            //tw.Show();
        }

        //public void ChangeChartInstrument(InstrumentViewModel instrument)
        //{
        //    //ChartPart.Instrument = instrument;
        //}
    }
}