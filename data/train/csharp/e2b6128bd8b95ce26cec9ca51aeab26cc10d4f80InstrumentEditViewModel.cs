using BuechiMvvm.Models;
using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BuechiMvvm.ViewModels
{
    public class InstrumentEditViewModel : ViewModelBase
    {
        private Instrument instrument;

        public InstrumentEditViewModel(Instrument instrument)
        {
            this.instrument = instrument;
        }

        [MaxLength(10, ErrorMessage = "Maximal 10!")]
        public string Name
        {
            get { return this.instrument.Name; }
            set
            {
                this.instrument.Name = value;
                RaisePropertyChanged();
            }
        }

        public InstrumentStatus Status
        {
            get { return this.instrument.Status; }
            set
            {
                this.instrument.Status = value;
                RaisePropertyChanged();
            }
        }
    }
}
