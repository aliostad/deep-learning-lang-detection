using AutoMapper;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using VetTrainer.Models;
using VetTrainer.Models.DataTransferObjs;

namespace VetTrainer.Controllers.Apis
{
    public class ClinicInstrumentModifyController : ApiController
    {
        VetAppDBContext _context = new VetAppDBContext();

        protected override void Dispose(bool disposing)
        {
            _context.Dispose();
        }

        public IHttpActionResult PostClinicInstrumentModify(InstrumentDto instrument)
        {
            string msg = "";
            if (instrument == null)
            {
                msg = "参数错误";
            }

            try
            {
                var instrumentToModify = _context.Instruments.Find(instrument.Id);
                _context.Entry(instrumentToModify).Collection(u => u.Texts).Load();
                _context.Entry(instrumentToModify).Collection(u => u.Pictures).Load();
                _context.Entry(instrumentToModify).Collection(u => u.Videos).Load();

                var instrumentToModifyDto = Mapper.Map<Instrument, InstrumentDto>(instrumentToModify);
                foreach (TextDto t in instrumentToModifyDto.Texts)
                {
                    var text = _context.Texts.Find(t.Id);
                    _context.Texts.Remove(text);
                }
                foreach (PictureDto p in instrumentToModifyDto.Pictures)
                {
                    var picture = _context.Pictures.Find(p.Id);
                    _context.Pictures.Remove(picture);
                }
                foreach (VideoDto v in instrumentToModifyDto.Videos)
                {
                    var video = _context.Videos.Find(v.Id);
                    _context.Videos.Remove(video);
                }
                instrumentToModify.Texts.Clear();
                foreach(TextDto t in instrument.Texts)
                {
                    var text = Mapper.Map<TextDto, Text>(t);
                    instrumentToModify.Texts.Add(text);
                }
                instrumentToModify.Pictures.Clear();
                foreach (PictureDto p in instrument.Pictures)
                {
                    var picture = Mapper.Map<PictureDto, Picture>(p);
                    instrumentToModify.Pictures.Add(picture);
                }
                instrumentToModify.Videos.Clear();
                foreach (VideoDto v in instrument.Videos)
                {
                    var video = Mapper.Map<VideoDto, Video>(v);
                    instrumentToModify.Videos.Add(video);
                }
                _context.Entry(instrumentToModify).State = EntityState.Modified;
                _context.SaveChanges();
                msg = "修改成功";
            }
            catch (RetryLimitExceededException)
            {
                msg = "网络故障";
            }
            var str = "{ \"Message\" : \"" + msg + "\" , \"" + "Data\" : \"" + "null" + "\" }";
            return Ok(str);
        }
    }
}
