using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Text;
using Admin.Model.Monitor_MDL;

namespace Admin.IDAL.Monitor_IDAL
{
    public interface IMonitorDispatchMstr
    {
        IList<MonitorDispatchMstr_MDL> selectMonitorDispatchMstr(string colname, string coltext);
        IList<MonitorDispatchMstr_MDL> selectMonitorDispatchMstr(string colname, string coltext,string DispatchStatus, int PageSize, int PageIndex, out int RowCount);
        IList<MonitorDispatchDtil_MDL> selectMonitorDispatchDtil(int vID);
    }
}
