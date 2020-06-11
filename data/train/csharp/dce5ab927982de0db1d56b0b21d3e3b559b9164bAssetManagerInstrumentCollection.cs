using System;
using System.Collections.Generic;
using System.Linq;
using B4F.TotalGiro.Collections.Persistence;
using B4F.TotalGiro.Instruments;

namespace B4F.TotalGiro.Stichting
{
    /// <summary>
    /// This class holds collection of instrument data that is specific to the AssetManager.
    /// </summary>
    public class AssetManagerInstrumentCollection : TransientDomainCollection<IAssetManagerInstrument>, IAssetManagerInstrumentCollection
    {
        public AssetManagerInstrumentCollection()
            : base() { }

        public AssetManagerInstrumentCollection(IAssetManager parent)
            : base()
        {
            Parent = parent;
        }

        /// <summary>
        /// Get/set associated Asset Manager
        /// </summary>
        public IAssetManager Parent { get; set; }

        public void AddInstrument(ITradeableInstrument instrument)
        {
            if (instrument == null)
                throw new ApplicationException("It is not possible to map a null instrument to an assetmanager");
            
            if (this.Where(u => u.Instrument.Key == instrument.Key).Count() > 0)
                throw new ApplicationException(string.Format("The instrument {0} is already mapped to assetmanager {1}", instrument.DisplayNameWithIsin, Parent.CompanyName));

            this.Add(new AssetManagerInstrument(Parent, instrument));
        }

        public IAssetManagerInstrument GetItemByInstrument(ITradeableInstrument instrument)
        {
            return this.Where(u => u.Instrument.Key == instrument.Key).FirstOrDefault();
        }
    }
}