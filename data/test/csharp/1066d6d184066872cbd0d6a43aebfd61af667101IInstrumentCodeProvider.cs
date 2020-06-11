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
	public interface IInstrumentCodeProvider
	{
		Business.InstrumentCode Select(Guid id);
		void Update(Business.InstrumentCode instrumentCode);
		void Delete(Business.InstrumentCode instrumentCode);
		void Insert(Business.InstrumentCode instrumentCode);
		IList<Core.Business.InstrumentCode> GetAllInstrumentCode();
	}
}
