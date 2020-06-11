using System;
using System.Collections.Generic;
using System.Web;

namespace LxyLab
{
    /// <summary>
    /// SaveInstrument 的摘要说明
    /// </summary>
    public class SaveInstrument : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            DataModel dm = new DataModel();
            Instrument lt = new Instrument();
            lt.InstrumentID = Convert.ToInt32(context.Request.Params["InstrumentID"]);
            lt.InstrumentName = context.Request.Params["InstrumentName"];
            lt.InstrumentIntro = context.Request.Params["InstrumentIntro"]; 
            lt.InstrumentAmount = Convert.ToInt32(context.Request.Params["InstrumentAmount"]);
            lt.InstrumentPer = Convert.ToInt32(context.Request.Params["InstrumentPer"]);
            dm.SaveInstrument(lt);
            dm.ReturnJsonMsg(context.Response, 1, "保存成功！", lt.InstrumentID); 
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}