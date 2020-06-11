using System;
using System.Text;
using System.Collections.Generic;
using System.Xml;
using System.Windows.Controls;
using System.ComponentModel;
using System.Collections.ObjectModel;

namespace Excel_Interface
{
    public abstract class InstrumentInfoViewModel : IXmlData
    {
        #region Event
        public event PropertyChangedEventHandler PropertyChanged;
        
        protected void NotifyPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
        #endregion
        
        public InstrumentInfoViewModel() { }
        
        #region Type_
        private string type_;
        public string Type_
        {
            get { return this.type_; }
            set
            {
                if (this.type_ != value)
                {
                    this.type_ = value;
                    this.NotifyPropertyChanged("Type_");
                }
            }
        }
        #endregion
        
        #region StandardInstrumentViewModel_
        private StandardInstrumentViewModel standardInstrumentViewModel_;
        public StandardInstrumentViewModel StandardInstrumentViewModel_
        {
            get { return this.standardInstrumentViewModel_; }
            set
            {
                if (this.standardInstrumentViewModel_ != value)
                {
                    this.standardInstrumentViewModel_ = value;
                    this.NotifyPropertyChanged("StandardInstrumentViewModel_");
                }
            }
        }
        #endregion
        
        #region StandardSwapInstrumentViewModel_
        private StandardSwapInstrumentViewModel standardSwapInstrumentViewModel_;
        public StandardSwapInstrumentViewModel StandardSwapInstrumentViewModel_
        {
            get { return this.standardSwapInstrumentViewModel_; }
            set
            {
                if (this.standardSwapInstrumentViewModel_ != value)
                {
                    this.standardSwapInstrumentViewModel_ = value;
                    this.NotifyPropertyChanged("StandardSwapInstrumentViewModel_");
                }
            }
        }
        #endregion
        
        #region CreditInstrumentViewModel_
        private CreditInstrumentViewModel creditInstrumentViewModel_;
        public CreditInstrumentViewModel CreditInstrumentViewModel_
        {
            get { return this.creditInstrumentViewModel_; }
            set
            {
                if (this.creditInstrumentViewModel_ != value)
                {
                    this.creditInstrumentViewModel_ = value;
                    this.NotifyPropertyChanged("CreditInstrumentViewModel_");
                }
            }
        }
        #endregion
        
        #region FixedBondInstrumentViewModel_
        private FixedBondInstrumentViewModel fixedBondInstrumentViewModel_;
        public FixedBondInstrumentViewModel FixedBondInstrumentViewModel_
        {
            get { return this.fixedBondInstrumentViewModel_; }
            set
            {
                if (this.fixedBondInstrumentViewModel_ != value)
                {
                    this.fixedBondInstrumentViewModel_ = value;
                    this.NotifyPropertyChanged("FixedBondInstrumentViewModel_");
                }
            }
        }
        #endregion
        
        public string choiceStr_0;
        
    
        public abstract void buildXml(System.Xml.XmlWriter xmlWriter);
        public abstract void setFromXml(System.Xml.XmlNode node);
        public abstract void setFromSerial(FpmlSerializedCSharp.ISerialized serial_Class);
        
    
        public static InstrumentInfoViewModel CreateInstrumentInfo(string typeStr)
        {
            if ( typeStr == "standardInstrument")
            {
                return new StandardInstrumentViewModel();
            }
            else if ( typeStr == "standardSwapInstrument")
            {
                return new StandardSwapInstrumentViewModel();
            }
            else if ( typeStr == "creditInstrument")
            {
                return new CreditInstrumentViewModel();
            }
            else if ( typeStr == "fixedBondInstrument")
            {
                return new FixedBondInstrumentViewModel();
            }
            else
            {
            throw new NotImplementedException();
            }
        }
        
        
    
    }
    
}

