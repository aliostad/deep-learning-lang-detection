using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Instrument.DataAccess;
using System.Collections;
using ToolsLib.IBatisNet;
using Instrument.Common;
using Instrument.Common.Models;
using GRGTCommonUtils;
using System.Data;
using Global.Common.Models;
using System.Web;
using ToolsLib.Utility;
using System.IO;

namespace Instrument.Business
{
    /// <summary>
    /// 实验室标准器具
    /// </summary>
    public class InstrumentCertificationServiceImpl
    {
        public void DeleteByInstrumentId(int InstrumentId)
        {
            DBProvider.InstrumentCertificationDAO.DeleteByInstrumentId(InstrumentId);
        }

        /// <summary>
        /// 删除记录.
        /// </summary>
        public string DeleteById(int LogId, int InstrumentId)
        {
            string msg = "OK";
            //IList<InstrumentCertificationModel> certList = GetByInstrumentId(InstrumentId);
            //if (certList.Count == 1) return "只有一条周期校准记录，不能删除";
            DBProvider.InstrumentCertificationDAO.DeleteById(LogId);
            //找出仪器下到期日期最大并且当前日期在有效期之内同时完成周检的证书记录并更新
            UpdateCertificationAndState(InstrumentId);

            Instrument.Common.Models.InstrumentModel model = new Instrument.Common.Models.InstrumentModel();
            model.InstrumentId = InstrumentId;
            model.LastUpdateUser = LoginHelper.LoginUser.UserName;
            ServiceProvider.InstrumentService.UpdateLastUpdateInfo(model);
            if (LoginHelper.LoginUserAuthorize.Contains("/Instrument/SynInstrument".ToLower()))
            {
                ServiceProvider.InstrumentService.BeginSynInstrument(InstrumentId);
            }
            return msg;
        }
        /// <summary>
        /// 找出仪器下到期日期最大并且当前日期在有效期之内同时完成周检的证书记录并更新
        /// </summary>
        /// <param name="instrumentId"></param>
        public void UpdateCertificationAndState(int instrumentId)
        {
            Instrument.Common.Models.InstrumentModel instrument = new Instrument.Common.Models.InstrumentModel();
            instrument.InstrumentId = instrumentId;
            //找出仪器下到期日期最大并且当前日期在有效期之内同时完成周检的证书记录
            InstrumentCertificationModel certModel = DBProvider.InstrumentCertificationDAO.GetMaxEndDateByInstrumentId(instrumentId,DateTime.Now.ToString("yyyy-MM-dd"));
            if (certModel == null)
            {                
                instrument = ServiceProvider.InstrumentService.GetById(instrumentId);
                instrument.CertificateNo = null;
                instrument.DueStartDate = null;
                instrument.DueEndDate = null;
                instrument.InspectOrg = null;
                if (instrument.ManageLevel != "C") instrument.RecordState = UtilConstants.InstrumentState.过期禁用.GetHashCode();
            }
            else
            {
                instrument.CertificateNo = certModel.CertificationCode;
                instrument.DueStartDate = certModel.CheckDate;
                instrument.DueEndDate = certModel.EndDate;
                instrument.InspectOrg = certModel.MeasureOrg;
                if (certModel.EndDate < DateTime.Now)
                {
                    instrument.RecordState = UtilConstants.InstrumentState.过期禁用.GetHashCode();
                    //找到，将该条记录设为正在使用
                    certModel.IsUseding = false;
                }
                else
                {
                    instrument.RecordState = UtilConstants.InstrumentState.合格.GetHashCode();
                    certModel.IsUseding = true;
                }
            }
            //更新仪器的证书信息
            ServiceProvider.InstrumentService.UpdateCertificationInfo(instrument);
            //更新当前证书正在使用状态，其他设为未使用
            UpdateIsUseding(certModel);
        }
        //同步周期校准记录时使用
        public void Insert(InstrumentCertificationModel model)
        {            
            DBProvider.InstrumentCertificationDAO.Add(model);
            //找出仪器下到期日期最大并且当前日期在有效期之内同时完成周检的证书记录并更新
            UpdateCertificationAndState(model.InstrumentId);
        }

        /// <summary>
        /// 保存实体数据.
        /// </summary>
        public void Save(InstrumentCertificationModel model, HttpFileCollectionBase Files)
        {
            if (Files.Count > 0 && Files[0].ContentLength > 0)
            {
                string targetPath = WebUtils.GetSettingsValue("InstrumentCertificationPath");
                string targetFile = string.Format(@"{0}/{1}{2}", targetPath, StrUtils.GetUniqueFileName(null), Path.GetExtension(Files[0].FileName));
                AttachmentModel attModel = UtilsHelper.FileUpload(Files[0], targetFile, (UtilConstants.ServerType)Convert.ToInt32(WebUtils.GetSettingsValue("WebFileType") == null ? "1" : WebUtils.GetSettingsValue("WebFileType")));
                attModel.FileType = (int)UtilConstants.AttachmentType.仪器周检证书;
                attModel.UserId = LoginHelper.LoginUser.UserId;
                attModel.UserName = LoginHelper.LoginUser.UserName;
                if (model.LogId != 0)//重新上传删除原来文件
                    Global.Business.ServiceProvider.AttachmentService.DeleteById(model.FileId);
                Global.Business.ServiceProvider.AttachmentService.Save(attModel);
                model.FileId = attModel.FileId;//新文件位置
                //model.FileVirtualPath = WebUtils.GetSettingsValue("WebFileServer")+targetFile;
            }
            if (model.LogId == 0)
            {
                model.CreateUser = LoginHelper.LoginUser.UserName;
                model.ItemCode = Guid.NewGuid().ToString();
                DBProvider.InstrumentCertificationDAO.Add(model);
            }
            else DBProvider.InstrumentCertificationDAO.Update(model);
            //找出仪器下到期日期最大并且当前日期在有效期之内同时完成周检的证书记录并更新
            UpdateCertificationAndState(model.InstrumentId);
            //更新上次修改人和修改时间
            Instrument.Common.Models.InstrumentModel instrumentModel = new Instrument.Common.Models.InstrumentModel();
            instrumentModel.InstrumentId = model.InstrumentId;
            instrumentModel.LastUpdateUser = LoginHelper.LoginUser.UserName;
            ServiceProvider.InstrumentService.UpdateLastUpdateInfo(instrumentModel);

            if (LoginHelper.LoginUserAuthorize.Contains("/Instrument/SynInstrument".ToLower()))
            {
               ServiceProvider.InstrumentService.BeginSynInstrument(model.InstrumentId);
            }

        }

        /// <summary>
        /// 保存实体数据.
        /// </summary>
        public void SaveCerAndPic(InstrumentCertificationModel model, HttpFileCollectionBase Files)
        {
            if (Files["certification"] != null)
            {
                string targetPath = WebUtils.GetSettingsValue("InstrumentCertificationPath");
                string targetFile = string.Format(@"{0}/{1}{2}", targetPath, StrUtils.GetUniqueFileName(null), Path.GetExtension(Files["certification"].FileName));
                AttachmentModel attModel = UtilsHelper.FileUpload(Files["certification"], targetFile, (UtilConstants.ServerType)Convert.ToInt32(WebUtils.GetSettingsValue("WebFileType") == null ? "1" : WebUtils.GetSettingsValue("WebFileType")));
                attModel.FileType = (int)UtilConstants.AttachmentType.仪器周检证书;
                attModel.UserId = LoginHelper.LoginUser.UserId;
                attModel.UserName = LoginHelper.LoginUser.UserName;
                if (model.LogId != 0)//重新上传删除原来文件
                    Global.Business.ServiceProvider.AttachmentService.DeleteById(model.FileId);
                Global.Business.ServiceProvider.AttachmentService.Save(attModel);
                model.FileId = attModel.FileId;//新文件位置
            }
            if (model.LogId == 0)
            {
                model.CreateUser = LoginHelper.LoginUser.UserName;
                model.ItemCode = Guid.NewGuid().ToString();
                DBProvider.InstrumentCertificationDAO.Add(model);
            }
            else DBProvider.InstrumentCertificationDAO.Update(model);
            //找出仪器下到期日期最大并且当前日期在有效期之内同时完成周检的证书记录并更新
            UpdateCertificationAndState(model.InstrumentId);
            //更新上次修改人和修改时间
            Instrument.Common.Models.InstrumentModel instrumentModel = new Instrument.Common.Models.InstrumentModel();
            instrumentModel.InstrumentId = model.InstrumentId;
            instrumentModel.LastUpdateUser = LoginHelper.LoginUser.UserName;
            ServiceProvider.InstrumentService.UpdateLastUpdateInfo(instrumentModel);

            if (LoginHelper.LoginUserAuthorize.Contains("/Instrument/SynInstrument".ToLower()))
            {
                ServiceProvider.InstrumentService.BeginSynInstrument(model.InstrumentId);
            }


        }

        public void Synchronous(InstrumentCertificationModel model, Stream stream, string fileName, string targetFileName)
        {
            //(System.IO.Stream inputStream, string sourceFileName, string targetFileName, UtilConstants.ServerType targetServer)
            if (stream != null)
            {
                AttachmentModel attModel = UtilsHelper.FileUpload(stream, fileName, targetFileName, (UtilConstants.ServerType)Convert.ToInt32(WebUtils.GetSettingsValue("WebFileType") == null ? "1" : WebUtils.GetSettingsValue("WebFileType")));
                attModel.FileType = (int)UtilConstants.AttachmentType.仪器周检证书;
                attModel.UserId = LoginHelper.LoginUser.UserId;
                attModel.UserName = LoginHelper.LoginUser.UserName;
                if (model.LogId != 0)//重新上传删除原来文件
                    Global.Business.ServiceProvider.AttachmentService.DeleteById(model.FileId);
                Global.Business.ServiceProvider.AttachmentService.Save(attModel);
                model.FileId = attModel.FileId;//新文件位置
            }
            if (model.LogId == 0)
            {
                model.CreateUser = LoginHelper.LoginUser.UserName;
                model.ItemCode = Guid.NewGuid().ToString();
                DBProvider.InstrumentCertificationDAO.Add(model);
            }
            else DBProvider.InstrumentCertificationDAO.Update(model);
            //找出仪器下到期日期最大并且当前日期在有效期之内同时完成周检的证书记录并更新
            UpdateCertificationAndState(model.InstrumentId);
            //更新上次修改人和修改时间
            Instrument.Common.Models.InstrumentModel instrumentModel = new Instrument.Common.Models.InstrumentModel();
            instrumentModel.InstrumentId = model.InstrumentId;
            instrumentModel.LastUpdateUser = LoginHelper.LoginUser.UserName;
            ServiceProvider.InstrumentService.UpdateLastUpdateInfo(instrumentModel);

            if (LoginHelper.LoginUserAuthorize.Contains("/Instrument/SynInstrument".ToLower()))
            {
                ServiceProvider.InstrumentService.BeginSynInstrument(model.InstrumentId);
            }

        }

        

        /// <summary>
        /// 仪器证书保存方法（不含附件信息）
        /// </summary>
        /// <param name="model"></param>
        public void SaveCert(InstrumentCertificationModel model)
        {
            if (model.LogId == 0)
            {
                model.CreateUser = LoginHelper.LoginUser.UserName;
                model.ItemCode = Guid.NewGuid().ToString();
                DBProvider.InstrumentCertificationDAO.Add(model);
            }
            else DBProvider.InstrumentCertificationDAO.Update(model);
        }


        public void UpdateFileIdByInstrumentIdAndOrderNo(int instrumentId,int fileId,string orderNo)
        {
            DBProvider.InstrumentCertificationDAO.UpdateFileIdByInstrumentIdAndOrderNo(instrumentId, fileId, orderNo);
        }
        /// <summary>
        /// 获取一个记录对象.
        /// </summary>
        public InstrumentCertificationModel GetById(int LogId)
        {
            return DBProvider.InstrumentCertificationDAO.GetById(LogId);
        }

        public InstrumentCertificationModel GetByCertificationCode(string certificationCode)
        {
            return DBProvider.InstrumentCertificationDAO.GetByCertificationCode(certificationCode);
        }
                /// <summary>
        /// 根据证书编号查找证书信息
        /// </summary>
        /// <param name="certificationCode"></param>
        /// <returns></returns>
        public IList<InstrumentCertificationModel> GetListByCertificationCode(string certificationCode)
        {
            return DBProvider.InstrumentCertificationDAO.GetListByCertificationCode(certificationCode);
        }

        public bool IsExistCertificationCode(int logId,string certificationCode)
        {
            return DBProvider.InstrumentCertificationDAO.IsExistCertificationCode(logId,certificationCode);
        }

        /// <summary>
        /// 更新证书编号，校准时间，到期日期
        /// </summary>
        /// <param name="model"></param>
        public void UpdateCertInfo(InstrumentCertificationModel model)
        {
            DBProvider.InstrumentCertificationDAO.UpdateCertInfo(model);
        }
        /// <summary>
        /// 更新当前证书正在使用状态，其他设为未使用
        /// </summary>
        /// <param name="model"></param>
        public void UpdateIsUseding(InstrumentCertificationModel model)
        {
            DBProvider.InstrumentCertificationDAO.UpdateIsUseding(model);
        }

        

        public IList<InstrumentCertificationModel> GetByInstrumentId(int instrumentId)
        {
            return DBProvider.InstrumentCertificationDAO.GetByInstrumentId(instrumentId);
        }

        /// <summary>
        /// 获取所有的记录对象.
        /// </summary>
        public IList<InstrumentCertificationModel> GetAll()
        {
            return DBProvider.InstrumentCertificationDAO.GetAll();
        }

        public IList<Hashtable> GetInstrumentCertificationListForPaging(PagingModel paging)
        {
            return DBProvider.InstrumentCertificationDAO.GetInstrumentCertificationListForPaging(paging);
        }

        /// <summary>
        /// 更新周检附件信息
        /// </summary>
        /// <param name="list"></param>
        public void UpdateCertFile(IList<InstrumentCertificationModel> list, AttachmentModel attachment)
        {
            foreach(InstrumentCertificationModel m in list)
            {
                m.FileId = attachment.FileId;
                DBProvider.InstrumentCertificationDAO.UpdateCertFile(m);
            }
        }
        /// <summary>
        /// 获得记录.
        /// </summary>
        public IList<InstrumentCertificationModel> GetByWhere(string where)
        {
            return DBProvider.InstrumentCertificationDAO.GetByWhere(where);
        }
        /// <summary>
        /// 获取仪器下最大的到期日期证书
        /// </summary>
        public  InstrumentCertificationModel GetMaxEndDateByInstrumentId(int instrumentId, string currentDate)
        {
            return DBProvider.InstrumentCertificationDAO.GetMaxEndDateByInstrumentId(instrumentId, currentDate);
        }

        /// <summary>
        /// 通过ID列表得到对象实体集合.
        /// </summary>
        public IList<InstrumentCertificationModel> GetByIds(IList<int> instrumentIdList)
        {
            List<InstrumentCertificationModel> InstrumentCertList = new List<InstrumentCertificationModel>();
            int maxLen = 500;
            int queryCount = instrumentIdList.Count / maxLen + (instrumentIdList.Count % maxLen == 0 ? 0 : 1);

            for (int i = 0; i < queryCount; i++)
            {
                var tempArray = instrumentIdList.Skip(i * maxLen).Take(maxLen).ToList();
                IList<InstrumentCertificationModel> certList = DBProvider.InstrumentCertificationDAO.GetByIds(tempArray);
                InstrumentCertList.AddRange(certList);
            }
            return InstrumentCertList;
        }
    }
}
