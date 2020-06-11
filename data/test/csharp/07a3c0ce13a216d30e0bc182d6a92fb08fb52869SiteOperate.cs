using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VehicleGPS.Models.DispatchCentre.SiteManage;

namespace VehicleGPS.Services.DispatchCentre.SiteManage
{
    class SiteOperate : IOperate<DispatchSiteInfo>
    {
        public List<DispatchSiteInfo>  ReadAllInfo()
        {
            List<DispatchSiteInfo> list_SiteInfo = new List<DispatchSiteInfo>();
            return list_SiteInfo;
        }


        public bool AddInfo(DispatchSiteInfo info)
        {
            throw new NotImplementedException();
        }

        public bool ModInfo(DispatchSiteInfo info)
        {
            throw new NotImplementedException();
        }

        public bool DelInfo(DispatchSiteInfo info)
        {
            throw new NotImplementedException();
        }
    }
}
