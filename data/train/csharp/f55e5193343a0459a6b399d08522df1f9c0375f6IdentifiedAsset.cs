using System;
using System.Text;
using System.Xml;
using CSharpCodeGen;

namespace FpmlSerializedCSharp
{
    public class IdentifiedAsset
    {
        public IdentifiedAsset(XmlNode xmlNode)
        : base(xmlNode)
        {
            XmlNodeList instrumentIdNodeList = xmlNode.SelectNodes("instrumentId");
            
            foreach (XmlNode item in instrumentIdNodeList)
            {
                if (item.Attributes["href"] != null || item.Attributes["id"] == null) 
                {
                    if (item.Attributes["id"] != null) 
                    {
                        instrumentIdIDRef = item.Attributes["id"].Name;
                        List<InstrumentId> ob = new List<InstrumentId>();
                        ob.Add(new InstrumentId(item));
                        IDManager.SetID(instrumentIdIDRef, ob);
                    }
                    else if (item.Attributes.ToString() == "href")
                    {
                        instrumentIdIDRef = item.Attributes["href"].Name;
                    }
                    else
                    {
                    instrumentId.Add(new InstrumentId(item));
                    }
                }
            }
            
        
            XmlNodeList descriptionNodeList = xmlNode.SelectNodes("description");
            if (descriptionNodeList.Count > 1 )
            {
                    throw new Exception();
            }
            
            foreach (XmlNode item in descriptionNodeList)
            {
                if (item.Attributes["href"] != null || item.Attributes["id"] == null) 
                {
                    if (item.Attributes["id"] != null) 
                    {
                        descriptionIDRef = item.Attributes["id"].Name;
                        XsdTypeString ob = XsdTypeString();
                        IDManager.SetID(descriptionIDRef, ob);
                    }
                    else if (item.Attributes.ToString() == "href")
                    {
                        descriptionIDRef = item.Attributes["href"].Name;
                    }
                    else
                    {
                        description = new XsdTypeString(item);
                    }
                }
            }
            
        
        }
        
    
        #region InstrumentId
        private List<InstrumentId> instrumentId;
        public List<InstrumentId> InstrumentId
        {
            get
            {
                if (this.instrumentId != null)
                {
                    return this.instrumentId; 
                }
                else if (this.instrumentIdIDRef != null)
                {
                    instrumentId = IDManager.getID(instrumentIdIDRef) as List<InstrumentId>;
                    return this.instrumentId; 
                }
                else
                {
                    throw new NotImplementedException();
                }
            }
            set
            {
                if (this.instrumentId != value)
                {
                    this.instrumentId = value;
                }
            }
        }
        #endregion
        
        public string InstrumentIdIDRef { get; set; }
        #region Description
        private XsdTypeString description;
        public XsdTypeString Description
        {
            get
            {
                if (this.description != null)
                {
                    return this.description; 
                }
                else if (this.descriptionIDRef != null)
                {
                    description = IDManager.getID(descriptionIDRef) as XsdTypeString;
                    return this.description; 
                }
                else
                {
                    throw new NotImplementedException();
                }
            }
            set
            {
                if (this.description != value)
                {
                    this.description = value;
                }
            }
        }
        #endregion
        
        public string XsdTypeStringIDRef { get; set; }
        
    
        
    
    }
    
}

