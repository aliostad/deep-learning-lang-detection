using SOS.Data.SosCrm;
using SOS.FunctionalServices.Contracts.Models.CentralStation;

namespace SOS.FunctionalServices.Models.CentralStation
{
	public class FnsMsDispatchAgencyView : IFnsMsDispatchAgencyView
	{
		#region .ctor

		public FnsMsDispatchAgencyView(MS_DispatchAgenciesView viewItem)
		{
			DispatchAgencyID = viewItem.DispatchAgencyID;
			DispatchAgencyTypeId = viewItem.DispatchAgencyTypeId;
			MonitoringStationOSId = viewItem.MonitoringStationOSId;
			DispatchAgencyOsId = viewItem.DispatchAgencyOsId;
			DispatchAgencyName = viewItem.DispatchAgencyName;
			MsAgencyNumber = viewItem.MsAgencyNumber;
			Address1 = viewItem.Address1;
			Address2 = viewItem.Address2;
			City = viewItem.City;
			State = viewItem.State;
			ZipCode = viewItem.ZipCode;
			Phone1 = viewItem.Phone1;
			Phone2 = viewItem.Phone2;
			DispatchAgencyType = viewItem.DispatchAgencyType;
		}

		#endregion .ctor

		#region Properties
		public int DispatchAgencyID { get; private set; }
		public short DispatchAgencyTypeId { get; private set; }
		public string MonitoringStationOSId { get; private set; }
		public int DispatchAgencyOsId { get; private set; }
		public string DispatchAgencyName { get; private set; }
		public string MsAgencyNumber { get; private set; }
		public string Address1 { get; private set; }
		public string Address2 { get; private set; }
		public string City { get; private set; }
		public string State { get; private set; }
		public string ZipCode { get; private set; }
		public string Phone1 { get; private set; }
		public string Phone2 { get; private set; }
		public string DispatchAgencyType { get; private set; }
		#endregion Properties
	}
}
