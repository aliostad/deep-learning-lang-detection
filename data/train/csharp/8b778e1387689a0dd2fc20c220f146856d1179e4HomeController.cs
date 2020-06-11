using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Mvc;
using ZerodhaClientSharp.Data;
using ZerodhaClientSharp.ZWebSocket;

namespace Future_BTST.Controllers
{
    public class HomeController : ZerodhaController
    {
        public void Index()
        {
           // ViewBag.Title = "Home Page";

            var redirectUri = ZClient.ZLogin.SiteLogin();

            //todo: try avoid getting context 
            var context = Request.Properties["MS_HttpContext"] as HttpContext;
            context.Response.Redirect(redirectUri);

        }
        [Route("Home/zerodha_response")]
        public string zerodha_response(string status, string request_token)
        {
            var response = ZClient.ZLogin.GetUserToken(request_token);
            var context = Request.Properties["MS_HttpContext"] as HttpContext;
            context.Session["UserToken"] = response ?? "Default";
            return response;
        }

public List<Instrument>  TestMe(bool test=true)
        {
            InstrumentData instrumentList = new InstrumentData();
            string instrumentFile=@"F:\Projects\MDX\Future_BTST\Future_BTST\InstrumentList.json";
           string instrumentJson=string.Empty;
           if (System.IO.File.Exists(instrumentFile))
               instrumentJson = System.IO.File.ReadAllText(instrumentFile);
           List<Instrument> instrumentDataList = new List<Instrument>();
           if (instrumentJson.Length > 0)
           {
               instrumentDataList = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Instrument>>(instrumentJson);
           }
           else
           {
               instrumentDataList = instrumentList.GetUnderlyingForFUT("aw230frvr95ajkzx", "NFO", "NSE", "FUT", "EQ", TimeSpan.FromDays(30));
               string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(instrumentDataList);
               System.IO.File.WriteAllText(instrumentFile, jsonData);
           }
           return instrumentDataList;
        }

        [HttpGet]
        public HttpResponseMessage  GetTopGainers(string p1,string p2,string p3)
{
    List<Instrument> ins = TestMe(true).Skip(0).ToList();
            
    MarketMovement move = new MarketMovement();
  var topG=   move.TopGainers(100, ins.Select(x => x.instrument_token).ToList());
  var combineWithInstrument = topG.Join(ins, x => x.instrument_token, y => y.instrument_token, (x, y) => 
        new { ID= y.tradingsymbol, LTP= x.Last_traded_price, volume= x.Volume_traded, change= x.Percentage_change });
  return Request.CreateResponse(HttpStatusCode.OK,combineWithInstrument);
}

    }
}
