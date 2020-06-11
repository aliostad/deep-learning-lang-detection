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
	public interface IVirtualLabInstrumentProvider
	{
		Business.VirtualLabInstrument Select(Guid id);
		void Update(Business.VirtualLabInstrument virtualLabInstrument);
		void Delete(Business.VirtualLabInstrument virtualLabInstrument);
		void Insert(Business.VirtualLabInstrument virtualLabInstrument);
		IList<Core.Business.VirtualLabInstrument> GetAllVirtualLabInstrument();
	}
}
