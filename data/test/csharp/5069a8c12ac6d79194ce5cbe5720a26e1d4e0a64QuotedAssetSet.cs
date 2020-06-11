using System;
using System.Text;
using System.Collections.Generic;
using System.Xml;

namespace FpmlSerializedCSharp
{
    public class QuotedAssetSet : ISerialized
    {
        public QuotedAssetSet(XmlNode xmlNode)
        {
            XmlNode instrumentSetNode = xmlNode.SelectSingleNode("instrumentSet");
            
            if (instrumentSetNode != null)
            {
                if (instrumentSetNode.Attributes["href"] != null || instrumentSetNode.Attributes["id"] != null) 
                {
                    if (instrumentSetNode.Attributes["id"] != null) 
                    {
                        instrumentSetIDRef_ = instrumentSetNode.Attributes["id"].Value;
                        InstrumentSet ob = new InstrumentSet(instrumentSetNode);
                        IDManager.SetID(instrumentSetIDRef_, ob);
                    }
                    else if (instrumentSetNode.Attributes["href"] != null)
                    {
                        instrumentSetIDRef_ = instrumentSetNode.Attributes["href"].Value;
                    }
                    else
                    {
                        instrumentSet_ = new InstrumentSet(instrumentSetNode);
                    }
                }
                else
                {
                    instrumentSet_ = new InstrumentSet(instrumentSetNode);
                }
            }
            
        
            XmlNodeList assetQuoteNodeList = xmlNode.SelectNodes("assetQuote");
            
            if (assetQuoteNodeList != null)
            {
                this.assetQuote_ = new List<BasicAssetValuation>();
                foreach (XmlNode item in assetQuoteNodeList)
                {
                    if (item.Attributes["href"] != null || item.Attributes["id"] != null) 
                    {
                        if (item.Attributes["id"] != null) 
                        {
                            assetQuoteIDRef_ = item.Attributes["id"].Value;
                            assetQuote_.Add(new BasicAssetValuation(item));
                            IDManager.SetID(assetQuoteIDRef_, assetQuote_[assetQuote_.Count - 1 ]);
                        }
                        else if (item.Attributes["href"] != null)
                        {
                            assetQuoteIDRef_ = item.Attributes["href"].Value;
                        }
                        else
                        {
                        assetQuote_.Add(new BasicAssetValuation(item));
                        }
                    }
                    else
                    {
                        assetQuote_.Add(new BasicAssetValuation(item));
                    }
                }
            }
            
        
        }
        
    
        #region InstrumentSet_
        private InstrumentSet instrumentSet_;
        public InstrumentSet InstrumentSet_
        {
            get
            {
                if (this.instrumentSet_ != null)
                {
                    return this.instrumentSet_; 
                }
                else if (this.instrumentSetIDRef_ != null)
                {
                    instrumentSet_ = IDManager.getID(instrumentSetIDRef_) as InstrumentSet;
                    return this.instrumentSet_; 
                }
                else
                {
                      return this.instrumentSet_; 
                }
            }
            set
            {
                if (this.instrumentSet_ != value)
                {
                    this.instrumentSet_ = value;
                }
            }
        }
        #endregion
        
        public string instrumentSetIDRef_ { get; set; }
        #region AssetQuote_
        private List<BasicAssetValuation> assetQuote_;
        public List<BasicAssetValuation> AssetQuote_
        {
            get
            {
                if (this.assetQuote_ != null)
                {
                    return this.assetQuote_; 
                }
                else if (this.assetQuoteIDRef_ != null)
                {
                    return this.assetQuote_; 
                }
                else
                {
                      return this.assetQuote_; 
                }
            }
            set
            {
                if (this.assetQuote_ != value)
                {
                    this.assetQuote_ = value;
                }
            }
        }
        #endregion
        
        public string assetQuoteIDRef_ { get; set; }
        
    
        
    
    }
    
}

