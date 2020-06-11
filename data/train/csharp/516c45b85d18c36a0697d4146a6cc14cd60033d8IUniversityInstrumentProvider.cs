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
	public interface IUniversityInstrumentProvider
	{
		Business.UniversityInstrument Select(Guid id);
		void Update(Business.UniversityInstrument universityInstrument);
		void Delete(Business.UniversityInstrument universityInstrument);
		void Insert(Business.UniversityInstrument universityInstrument);
		IList<Core.Business.UniversityInstrument> GetAllUniversityInstrument();

        IList<CY.CSTS.Core.Business.UniversityInstrument> GetUniInstruWhere(string SQLWhere);

        IList<CY.CSTS.Core.Business.UniversityInstrument> GetAllUniInstruWhere(string SQLWhere);
    }
}
