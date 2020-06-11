using Pharos.Logic.ApiData.Pos.DAL;
using Pharos.Logic.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Pharos.Logic.ApiData.Pos.Entity.LocalCeEntity;
using Pharos.Logic.ApiData.Pos.ValueObject;

namespace Pharos.Logic.ApiData.Pos.Services.LocalCeServices
{
    public class ApiLibraryService : BaseGeneralService<ApiLibrary, LocalCeDbContext>
    {
        public static ApiSetting GetApiSettings(int apiCode)
        {
            IsForcedExpired = true;
            return CurrentRepository.Entities.Where(o => o.ApiCode == apiCode).Select(o => new ApiSetting()
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
