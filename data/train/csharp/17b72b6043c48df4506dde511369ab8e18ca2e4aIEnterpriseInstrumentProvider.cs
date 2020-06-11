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
	public interface IEnterpriseInstrumentProvider
	{
		Business.EnterpriseInstrument Select(Guid id);
		void Update(Business.EnterpriseInstrument enterpriseInstrument);
		void Delete(Business.EnterpriseInstrument enterpriseInstrument);
		void Insert(Business.EnterpriseInstrument enterpriseInstrument);
		IList<Core.Business.EnterpriseInstrument> GetAllEnterpriseInstrument();
	}
}
