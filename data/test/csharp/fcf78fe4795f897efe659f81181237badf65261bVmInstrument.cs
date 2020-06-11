using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using ManagerConsole.Helper;
using Manager.Common.QuotationEntities;
using ManagerConsole.Model;
using System.Windows;

namespace ManagerConsole.ViewModel
{
    public class VmInstrument : VmQuotationBase
    {
        private Instrument _Instrument;
        public VmInstrument(Instrument instrument)
            : base(instrument)
        {
            this._Instrument = instrument;
            if (!instrument.IsDerivative)
            {
                this.SourceRelations = new ObservableCollection<VmInstrumentSourceRelation>();
                this.SourceRelations.CollectionChanged += SourceRelations_CollectionChanged;
            }
        }

        public VmInstrument()
            : base(null)
        {

        }

        private void SourceRelations_CollectionChanged(object sender, NotifyCollectionChangedEventArgs e)
        {
            int step = 20;
            int firstZIndex = (this.SourceRelations.Count - 1) * step;
            
            for (int i = 0; i < this.SourceRelations.Count; i++)
            {
                this.SourceRelations[i].ZIndex = firstZIndex - i * step;
                this.SourceRelations[i].Left = i * 100;
            }
        }

        public ObservableCollection<VmInstrumentSourceRelation> SourceRelations { get; set; }
        public VmPriceRangeCheckRule VmPriceRangeCheckRule { get; set; }
        public VmWeightedPriceRule VmWeightedPriceRule { get; set; }

        public VmDerivativeRelation VmDerivativeRelation { get; set; }

        public Instrument Instrument { get { return this._Instrument; } }
        public int Id { get { return this._Instrument.Id; } set { this._Instrument.Id = value; } }

        public string Code
        {
            get
            {
                return this._Instrument.Code;
            }
            set
            {
                if (this._Instrument.Code != value)
                {
                    this._Instrument.Code = value;
                    this.OnPropertyChanged(FieldSR.Code);
                }
            }
        }

        public int AdjustPoints
        {
            get
            {
                return this._Instrument.AdjustPoints;
            }
            set
            {
                if (this._Instrument.AdjustPoints != value)
                {
                    this.SubmitChange(MetadataType.Instrument, FieldSR.AdjustPoints, value);
                }
            }
        }
        public int AdjustIncrement
        {
            get
            {
                return this._Instrument.AdjustIncrement;
            }
            set
            {
                if (this._Instrument.AdjustIncrement != value)
                {
                    base.SubmitChange(MetadataType.Instrument, FieldSR.AdjustIncrement, value);
                }
            }
        }
        public bool IsDerivative
        {
            get
            {
                return this._Instrument.IsDerivative;
            }
            set
            {
                if (this._Instrument.IsDerivative != value)
                {
                    this._Instrument.IsDerivative = value;
                    this.OnPropertyChanged(FieldSR.IsDerivative);
                }
            }
        }

        public int DecimalPlace
        {
            get
            {
                return this._Instrument.DecimalPlace;
            }
            set
            {
                if (this._Instrument.DecimalPlace != value)
                {
                    base.SubmitChange(MetadataType.Instrument, FieldSR.DecimalPlace, value);
                }
            }
        }

        public int? InactiveTime
        {
            get
            {
                return this._Instrument.InactiveTime;
            }
            set
            {
                if (this._Instrument.InactiveTime != value)
                {
                    base.SubmitChange(MetadataType.Instrument, FieldSR.InactiveTime, value);
                }
            }
        }

        public bool? UseWeightedPrice
        {
            get
            {
                return this._Instrument.UseWeightedPrice;
            }
            set
            {
                if (this._Instrument.UseWeightedPrice != value)
                {
                    this._Instrument.UseWeightedPrice = value;
                    this.OnPropertyChanged(FieldSR.UseWeightedPrice);
                }
            }
        }

        public bool? IsSwitchUseAgio
        {
            get
            {
                return this._Instrument.IsSwitchUseAgio;
            }
            set
            {
                if (this._Instrument.IsSwitchUseAgio != value)
                {
                    this._Instrument.IsSwitchUseAgio = value;
                    this.OnPropertyChanged(FieldSR.IsSwitchUseAgio);
                }
            }
        }

        public int? AgioSeconds
        {
            get
            {
                return this._Instrument.AgioSeconds;
            }
            set
            {
                if (this._Instrument.AgioSeconds != value)
                {
                    this._Instrument.AgioSeconds = value;
                    this.OnPropertyChanged(FieldSR.AgioSeconds);
                }
            }
        }

        public int? LeastTicks
        {
            get
            {
                return this._Instrument.LeastTicks;
            }
            set
            {
                if (this._Instrument.LeastTicks != value)
                {
                    this._Instrument.LeastTicks = value;
                    this.OnPropertyChanged(FieldSR.LeastTicks);
                }
            }
        }

        public bool IsActive
        {
            get
            {
                return this._Instrument.IsActive;
            }
            set
            {
                if (this._Instrument.IsActive != value)
                {
                    this._Instrument.IsActive = value;
                    this.OnPropertyChanged(FieldSR.IsActive);
                }
            }
        }

        public bool HasDefaultSourceRelation
        {
            get
            {
                return this.SourceRelations.Any(r => r.IsDefault == true);
            }
        }

        public Visibility SendButtonVisibility
        {
            get { return this.IsDerivative ? Visibility.Hidden : Visibility.Visible; }
        }
        public Visibility DerivedControlVisibility
        {
            get { return this.IsDerivative ? Visibility.Visible : Visibility.Hidden; }
        }

        public int TempProperty { get; set; }

        //private string FloatFormat
        //{
        //    get { return 'F' + this.DecimalPlace.ToString(); }
        //}
    }
}
