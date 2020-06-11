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
	public interface IExhibitionInstrumentProvider
	{
		Business.ExhibitionInstrument Select(Guid id);
		void Update(Business.ExhibitionInstrument exhibitionInstrument);
		void Delete(Business.ExhibitionInstrument exhibitionInstrument);
		void Insert(Business.ExhibitionInstrument exhibitionInstrument);
        IList<Core.Business.ExhibitionInstrument> GetAllExhibitionInstrument(string strWhere);
        IList<Core.Business.ExhibitionInstrument> GetExhibitionInstrumentByPage(string sqlwhere, int pagenumber, int pagesize);
        IList<Core.Business.ExhibitionInstrument> GetExhibitionInstrumentTopBySequenceNumber(int num);
	}
}
