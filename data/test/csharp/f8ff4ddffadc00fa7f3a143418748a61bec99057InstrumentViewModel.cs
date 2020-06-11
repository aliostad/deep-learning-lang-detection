using BuechiMvvm.DAL;
using BuechiMvvm.Models;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace BuechiMvvm.ViewModels
{
    public class InstrumentViewModel : ViewModelBase
    {
        private IInstrumentManager instrumentManager;

        //implemented in ObservableObject base class
        //public event PropertyChangedEventHandler PropertyChanged;

        private ObservableCollection<InstrumentEditViewModel> instruments;

        public ObservableCollection<InstrumentEditViewModel> Instruments
        {
            get { return instruments; }
            set
            {
                //instruments = value;
                //this.RaisePropertyChanged();

                this.Set(ref instruments, value);
            }
        }

        private IEnumerable<InstrumentStatus> instrumentStatus;

        public IEnumerable<InstrumentStatus> InstrumentStatus
        {
            get { return instrumentStatus; }
            set { this.Set(ref instrumentStatus, value); }
        }



        private InstrumentEditViewModel selectedInstrument;

        public InstrumentEditViewModel SelectedInstrument
        {
            get { return selectedInstrument; }
            set { this.Set(ref selectedInstrument, value); }
        }

        private bool isLoading;

        public bool IsLoading
        {
            get { return isLoading; }
            set { this.Set(ref isLoading, value);  }
        }

        public ICommand LoadInstrumentsCommand { get; set; }

        public ICommand AddInstrumentsCommand { get; set; }

        public InstrumentViewModel(IInstrumentManager instrumentManager)
        {
            this.instrumentManager = instrumentManager;

            this.LoadInstrumentsCommand = new RelayCommand(async () => await LoadInstruments());

            this.AddInstrumentsCommand = new RelayCommand(() => {
                this.Instruments.Add(new InstrumentEditViewModel(new Instrument()
                {
                    Name = "L200",
                    Ip = new IpAddress(10, 10, 10, 1)
                }));
            });

            // not possible in constructor
            //await LoadInstruments();
        }

        private async Task LoadInstruments()
        {
            this.IsLoading = true;

            this.InstrumentStatus = await this.instrumentManager.GetAvailableStatusAsync();

            var instruments = await this.instrumentManager.GetInstrumentsAsync();

            this.Instruments = new ObservableCollection<InstrumentEditViewModel>(
                instruments.Select(i => new InstrumentEditViewModel(i))
            );

            this.SelectedInstrument = this.Instruments.First();

            this.IsLoading = false;
        }
    }
}
