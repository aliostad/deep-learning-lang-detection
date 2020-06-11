using System;
using System.Text;
using System.Collections.Generic;
using System.Xml;

namespace FpmlSerializedCSharp
{
    public class InstrumentInfo : ISerialized
    {
        public InstrumentInfo() { }
        public InstrumentInfo(XmlNode xmlNode)
        : base(xmlNode)
        {
            XmlNode typeNode = xmlNode.SelectSingleNode("type");
            
            if (typeNode != null)
            {
                if (typeNode.Attributes["href"] != null || typeNode.Attributes["id"] != null) 
                {
                    if (typeNode.Attributes["id"] != null) 
                    {
                        typeIDRef_ = typeNode.Attributes["id"].Value;
                        XsdTypeToken ob = new XsdTypeToken(typeNode);
                        IDManager.SetID(typeIDRef_, ob);
                    }
                    else if (typeNode.Attributes["href"] != null)
                    {
                        typeIDRef_ = typeNode.Attributes["href"].Value;
                    }
                    else
                    {
                        type_ = new XsdTypeToken(typeNode);
                    }
                }
                else
                {
                    type_ = new XsdTypeToken(typeNode);
                }
            }
            
        
            XmlNode standardInstrumentNode = xmlNode.SelectSingleNode("standardInstrument");
            
            if (standardInstrumentNode != null)
            {
                if (standardInstrumentNode.Attributes["href"] != null || standardInstrumentNode.Attributes["id"] != null) 
                {
                    if (standardInstrumentNode.Attributes["id"] != null) 
                    {
                        standardInstrumentIDRef_ = standardInstrumentNode.Attributes["id"].Value;
                        StandardInstrument ob = new StandardInstrument(standardInstrumentNode);
                        IDManager.SetID(standardInstrumentIDRef_, ob);
                    }
                    else if (standardInstrumentNode.Attributes["href"] != null)
                    {
                        standardInstrumentIDRef_ = standardInstrumentNode.Attributes["href"].Value;
                    }
                    else
                    {
                        standardInstrument_ = new StandardInstrument(standardInstrumentNode);
                    }
                }
                else
                {
                    standardInstrument_ = new StandardInstrument(standardInstrumentNode);
                }
            }
            
        
            XmlNode standardSwapInstrumentNode = xmlNode.SelectSingleNode("standardSwapInstrument");
            
            if (standardSwapInstrumentNode != null)
            {
                if (standardSwapInstrumentNode.Attributes["href"] != null || standardSwapInstrumentNode.Attributes["id"] != null) 
                {
                    if (standardSwapInstrumentNode.Attributes["id"] != null) 
                    {
                        standardSwapInstrumentIDRef_ = standardSwapInstrumentNode.Attributes["id"].Value;
                        StandardSwapInstrument ob = new StandardSwapInstrument(standardSwapInstrumentNode);
                        IDManager.SetID(standardSwapInstrumentIDRef_, ob);
                    }
                    else if (standardSwapInstrumentNode.Attributes["href"] != null)
                    {
                        standardSwapInstrumentIDRef_ = standardSwapInstrumentNode.Attributes["href"].Value;
                    }
                    else
                    {
                        standardSwapInstrument_ = new StandardSwapInstrument(standardSwapInstrumentNode);
                    }
                }
                else
                {
                    standardSwapInstrument_ = new StandardSwapInstrument(standardSwapInstrumentNode);
                }
            }
            
        
            XmlNode creditInstrumentNode = xmlNode.SelectSingleNode("creditInstrument");
            
            if (creditInstrumentNode != null)
            {
                if (creditInstrumentNode.Attributes["href"] != null || creditInstrumentNode.Attributes["id"] != null) 
                {
                    if (creditInstrumentNode.Attributes["id"] != null) 
                    {
                        creditInstrumentIDRef_ = creditInstrumentNode.Attributes["id"].Value;
                        CreditInstrument ob = new CreditInstrument(creditInstrumentNode);
                        IDManager.SetID(creditInstrumentIDRef_, ob);
                    }
                    else if (creditInstrumentNode.Attributes["href"] != null)
                    {
                        creditInstrumentIDRef_ = creditInstrumentNode.Attributes["href"].Value;
                    }
                    else
                    {
                        creditInstrument_ = new CreditInstrument(creditInstrumentNode);
                    }
                }
                else
                {
                    creditInstrument_ = new CreditInstrument(creditInstrumentNode);
                }
            }
            
        
            XmlNode fixedBondInstrumentNode = xmlNode.SelectSingleNode("fixedBondInstrument");
            
            if (fixedBondInstrumentNode != null)
            {
                if (fixedBondInstrumentNode.Attributes["href"] != null || fixedBondInstrumentNode.Attributes["id"] != null) 
                {
                    if (fixedBondInstrumentNode.Attributes["id"] != null) 
                    {
                        fixedBondInstrumentIDRef_ = fixedBondInstrumentNode.Attributes["id"].Value;
                        FixedBondInstrument ob = new FixedBondInstrument(fixedBondInstrumentNode);
                        IDManager.SetID(fixedBondInstrumentIDRef_, ob);
                    }
                    else if (fixedBondInstrumentNode.Attributes["href"] != null)
                    {
                        fixedBondInstrumentIDRef_ = fixedBondInstrumentNode.Attributes["href"].Value;
                    }
                    else
                    {
                        fixedBondInstrument_ = new FixedBondInstrument(fixedBondInstrumentNode);
                    }
                }
                else
                {
                    fixedBondInstrument_ = new FixedBondInstrument(fixedBondInstrumentNode);
                }
            }
            
        
        }
        
    
        #region Type_
        private XsdTypeToken type_;
        public XsdTypeToken Type_
        {
            get
            {
                if (this.type_ != null)
                {
                    return this.type_; 
                }
                else if (this.typeIDRef_ != null)
                {
                    type_ = IDManager.getID(typeIDRef_) as XsdTypeToken;
                    return this.type_; 
                }
                else
                {
                    throw new Exception( "type_Node no exist!");
                }
            }
            set
            {
                if (this.type_ != value)
                {
                    this.type_ = value;
                }
            }
        }
        #endregion
        
        public string typeIDRef_ { get; set; }
        #region StandardInstrument_
        private StandardInstrument standardInstrument_;
        public StandardInstrument StandardInstrument_
        {
            get
            {
                if (this.standardInstrument_ != null)
                {
                    return this.standardInstrument_; 
                }
                else if (this.standardInstrumentIDRef_ != null)
                {
                    standardInstrument_ = IDManager.getID(standardInstrumentIDRef_) as StandardInstrument;
                    return this.standardInstrument_; 
                }
                else
                {
                    throw new Exception( "standardInstrument_Node no exist!");
                }
            }
            set
            {
                if (this.standardInstrument_ != value)
                {
                    this.standardInstrument_ = value;
                }
            }
        }
        #endregion
        
        public string standardInstrumentIDRef_ { get; set; }
        #region StandardSwapInstrument_
        private StandardSwapInstrument standardSwapInstrument_;
        public StandardSwapInstrument StandardSwapInstrument_
        {
            get
            {
                if (this.standardSwapInstrument_ != null)
                {
                    return this.standardSwapInstrument_; 
                }
                else if (this.standardSwapInstrumentIDRef_ != null)
                {
                    standardSwapInstrument_ = IDManager.getID(standardSwapInstrumentIDRef_) as StandardSwapInstrument;
                    return this.standardSwapInstrument_; 
                }
                else
                {
                    throw new Exception( "standardSwapInstrument_Node no exist!");
                }
            }
            set
            {
                if (this.standardSwapInstrument_ != value)
                {
                    this.standardSwapInstrument_ = value;
                }
            }
        }
        #endregion
        
        public string standardSwapInstrumentIDRef_ { get; set; }
        #region CreditInstrument_
        private CreditInstrument creditInstrument_;
        public CreditInstrument CreditInstrument_
        {
            get
            {
                if (this.creditInstrument_ != null)
                {
                    return this.creditInstrument_; 
                }
                else if (this.creditInstrumentIDRef_ != null)
                {
                    creditInstrument_ = IDManager.getID(creditInstrumentIDRef_) as CreditInstrument;
                    return this.creditInstrument_; 
                }
                else
                {
                    throw new Exception( "creditInstrument_Node no exist!");
                }
            }
            set
            {
                if (this.creditInstrument_ != value)
                {
                    this.creditInstrument_ = value;
                }
            }
        }
        #endregion
        
        public string creditInstrumentIDRef_ { get; set; }
        #region FixedBondInstrument_
        private FixedBondInstrument fixedBondInstrument_;
        public FixedBondInstrument FixedBondInstrument_
        {
            get
            {
                if (this.fixedBondInstrument_ != null)
                {
                    return this.fixedBondInstrument_; 
                }
                else if (this.fixedBondInstrumentIDRef_ != null)
                {
                    fixedBondInstrument_ = IDManager.getID(fixedBondInstrumentIDRef_) as FixedBondInstrument;
                    return this.fixedBondInstrument_; 
                }
                else
                {
                    throw new Exception( "fixedBondInstrument_Node no exist!");
                }
            }
            set
            {
                if (this.fixedBondInstrument_ != value)
                {
                    this.fixedBondInstrument_ = value;
                }
            }
        }
        #endregion
        
        public string fixedBondInstrumentIDRef_ { get; set; }
        public string choiceStr_0;
        
    
        
    
    }
    
}

