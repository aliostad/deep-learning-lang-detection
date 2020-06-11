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
	public interface IINSTRUMENTProvider
	{
		Business.INSTRUMENT Select(Guid id);
		void Update(Business.INSTRUMENT iNSTRUMENT);
		void Delete(Business.INSTRUMENT iNSTRUMENT);
		void Insert(Business.INSTRUMENT iNSTRUMENT);
		IList<Core.Business.INSTRUMENT> GetAllINSTRUMENT();

        IList<CY.CSTS.Core.Business.INSTRUMENT> GetAllInstrumentsFromThreeTable();
        IList<Core.Business.INSTRUMENT> SelectINSTRUMENTByAndLabID(Guid labID);
    }
}
