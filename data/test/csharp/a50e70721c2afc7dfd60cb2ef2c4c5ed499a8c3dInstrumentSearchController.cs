using AutoMapper;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Script.Serialization;
using VetTrainer.Models;
using VetTrainer.Models.DataTransferObjs;

namespace VetTrainer.Controllers.Apis
{
    public class InstrumentSearchController : ApiController
    {
        VetAppDBContext _context = new VetAppDBContext();
        // GET: RoleSearch
        protected override void Dispose(bool disposing)
        {
            _context.Dispose();
        }
        public IHttpActionResult GetSearchResult()
        {
            string msg = "";
            var instrumentDtos = new List<InstrumentDto>();
            try
            {
                List<Instrument> instruments = new List<Instrument>();
                instruments = _context.Instruments.ToList();
                foreach (Instrument instrument in instruments)
                {
                    var instrumentDto = Mapper.Map<Instrument, InstrumentDto>(instrument);
                    instrumentDtos.Add(instrumentDto);
                }
                if (instrumentDtos.Count > 0)
                    msg = "查找成功";
                else
                    msg = "没有结果";

            }
            catch (RetryLimitExceededException)
            {
                msg = "网络故障";
            }
            JavaScriptSerializer jss = new JavaScriptSerializer();
            var str = "{ \"Message\" : \"" + msg + "\" , \"" + "Data\" : " + jss.Serialize(instrumentDtos) + " }";
            return Ok(str);
        }
        //获取查询用户信息结果api
        public IHttpActionResult GetSearchResult(string searchText)
        {
            string msg = "";
            var instrumentDtos = new List<InstrumentDto>();
            try
            {
                List<Instrument> instruments = new List<Instrument>();
                if (searchText == null || searchText.Trim() == "")
                {
                    instruments = _context.Instruments.ToList();
                }
                else
                {
                    instruments = _context.Instruments.Where(u => u.Name.Contains(searchText)).ToList();
                }
                foreach (Instrument user in instruments)
                {
                    var instrumentDto = Mapper.Map<Instrument, InstrumentDto>(user);
                    instrumentDtos.Add(instrumentDto);
                }
                if (instrumentDtos.Count > 0)
                    msg = "查找成功";
                else
                    msg = "没有结果";

            }
            catch (RetryLimitExceededException)
            {
                msg = "网络故障";
            }
            JavaScriptSerializer jss = new JavaScriptSerializer();
            var str = "{ \"Message\" : \"" + msg + "\" , \"" + "Data\" : " + jss.Serialize(instrumentDtos) + " }";
            return Ok(str);
        }

        public IHttpActionResult GetInstrumentByClinicID(int id)
        {
            string msg = string.Empty;
            var instrumentDtos = new List<InstrumentDto>();
            try
            {
                Clinic theClinic = _context.Clinics.Include(c => c.Instruments).SingleOrDefault(c => c.Id == id);
                if (theClinic != null)
                {
                    List<Instrument> instruments = new List<Instrument>(theClinic.Instruments);
                    foreach (Instrument instrument in instruments)
                    {
                        var instrumentDto = Mapper.Map<Instrument, InstrumentDto>(instrument);
                        instrumentDtos.Add(instrumentDto);
                    }
                    if (instrumentDtos.Count > 0)
                        msg = "查找成功";
                    else
                        msg = "没有结果";
                }
            }
            catch (RetryLimitExceededException)
            {
                msg = "网络故障";
            }
            JavaScriptSerializer jss = new JavaScriptSerializer();
            var str = "{ \"Message\" : \"" + msg + "\" , \"" + "Data\" : " + jss.Serialize(instrumentDtos) + " }";
            return Ok(str);
        }
    }
}
