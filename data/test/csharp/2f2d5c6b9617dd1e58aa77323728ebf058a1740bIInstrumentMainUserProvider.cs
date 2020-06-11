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
	public interface IInstrumentMainUserProvider
	{
		Business.InstrumentMainUser Select(Guid id);
		void Update(Business.InstrumentMainUser instrumentMainUser);
		void Delete(Business.InstrumentMainUser instrumentMainUser);
		void Insert(Business.InstrumentMainUser instrumentMainUser);
		IList<Core.Business.InstrumentMainUser> GetAllInstrumentMainUser();
	}
}
