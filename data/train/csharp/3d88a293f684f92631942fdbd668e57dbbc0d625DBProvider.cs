using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ToolsLib.Utility;

namespace Global.Instrument.DataAccess
{
    public class DBProvider
    {
        public static ToolsLib.IBatisNet.BaseMapper dbMapper { get; set; }



        public static InstrumentDaoImpl InstrumentDAO { get; set; }
        public static InstrumentCheckLogDaoImpl InstrumentCheckLogDAO { get; set; }
        public static InstrumentUsingPlanDaoImpl InstrumentUsingPlanDAO { get; set; }
        
    }
}
