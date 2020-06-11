using Pharos.Logic.ApiData.Pos.ValueObject;
using Pharos.Logic.BLL;
using Pharos.Logic.DAL;
using Pharos.Logic.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Pharos.Logic.ApiData.Pos.Services
{
    public class ApiLibraryService : BaseGeneralService<Pharos.Logic.Entity.ApiLibrary, EFDbContext>
    {

        public static ApiSetting GetApiSettings(int apiCode, int companyId)
        {
            return CurrentRepository.Entities.Where(o => o.CompanyId == companyId && o.ApiCode == apiCode).Select(o => new ApiSetting()
            {
                ApiAccount = o.ApiAccount,
                ApiCloseIcon = o.ApiCloseIcon,
                ApiCode = o.ApiCode,
                ApiIcon = o.ApiIcon,
                ApiOrder = o.ApiOrder,
                ApiPwd = o.ApiPwd,
                ApiToken = o.ApiToken,
                ApiType = o.ApiType,
                ApiUrl = o.ApiUrl,
                Memo = o.Memo,
                ReqMode = o.ReqMode,
                State = o.State,
                Title = o.Title
            }).FirstOrDefault();
        }
    }
}
