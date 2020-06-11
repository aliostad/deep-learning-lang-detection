#region Using
using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
#endregion Using

namespace CY.CSTS.Core.Providers.DALProvider
{
    public interface IInstrumentRecommendProvider
    {
        Business.InstrumentRecommend Select(Guid id);
        void Update(Business.InstrumentRecommend instrumentRecommend);
        void Delete(Business.InstrumentRecommend instrumentRecommend);
        void Insert(Business.InstrumentRecommend instrumentRecommend);
        IList<CY.CSTS.Core.Business.InstrumentRecommend> GetAllInstrumentRecommend();
    }
}
