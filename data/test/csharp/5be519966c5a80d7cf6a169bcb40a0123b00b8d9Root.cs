using System;
using System.Text;
using System.Collections.Generic;
using System.Xml;

namespace FpmlSerializedCSharp
{
    public class Root : ISerialized
    {
        public Root() { }
        public Root(XmlNode xmlNode)
        : base(xmlNode)
        {
            XmlNode instrumentNode = xmlNode.SelectSingleNode("instrument");
            
            if (instrumentNode != null)
            {
                if (instrumentNode.Attributes["href"] != null || instrumentNode.Attributes["id"] != null) 
                {
                    if (instrumentNode.Attributes["id"] != null) 
                    {
                        instrumentIDRef_ = instrumentNode.Attributes["id"].Value;
                        Instrument ob = new Instrument(instrumentNode);
                        IDManager.SetID(instrumentIDRef_, ob);
                    }
                    else if (instrumentNode.Attributes["href"] != null)
                    {
                        instrumentIDRef_ = instrumentNode.Attributes["href"].Value;
                    }
                    else
                    {
                        instrument_ = new Instrument(instrumentNode);
                    }
                }
                else
                {
                    instrument_ = new Instrument(instrumentNode);
                }
            }
            
        
        }
        
    
        #region Instrument_
        private Instrument instrument_;
        public Instrument Instrument_
        {
            get
            {
                if (this.instrument_ != null)
                {
                    return this.instrument_; 
                }
                else if (this.instrumentIDRef_ != null)
                {
                    instrument_ = IDManager.getID(instrumentIDRef_) as Instrument;
                    return this.instrument_; 
                }
                else
                {
                    throw new Exception( "instrument_Node no exist!");
                }
            }
            set
            {
                if (this.instrument_ != value)
                {
                    this.instrument_ = value;
                }
            }
        }
        #endregion
        
        public string instrumentIDRef_ { get; set; }
        
    
        
    
    }
    
}

