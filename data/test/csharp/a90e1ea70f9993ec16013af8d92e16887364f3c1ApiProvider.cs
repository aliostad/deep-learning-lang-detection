using System;
using System.Collections.Generic;
using Tuan.Entity;

namespace Tuan.Api
{
    public class ApiProvider
    {
        public static IList<TuanGou> GetTuanGouList(int apiTypeID, string apiUrl)
        {
            switch (apiTypeID)
            {
                case 1:
                    return new Tuan.Api.Hao123.Hao123Api(apiUrl).TuanGouList;
                case 2:
                    return new Tuan.Api.Fanwe.FanweApi(apiUrl).TuanGouList;
                case 3:
                    return new Tuan.Api.Tuan800.Tuan800Api(apiUrl).TuanGouList;
                case 4:
                    return new Tuan.Api.Tuanp.TuanpApi(apiUrl).TuanGouList;
                case 5:
                    return new Tuan.Api.Sohu.SohuApi(apiUrl).TuanGouList;
                case 6:
                    return new Tuan.Api.Letyo.LetyoApi(apiUrl).TuanGouList;
                case 7:
                    return new Tuan.Api.LashouOld.LashouOldApi(apiUrl).TuanGouList;
                case 8:
                    return new Tuan.Api.TuanLet.TuanLetApi(apiUrl).TuanGouList;
                default:
                    throw new Exception("该类型API不存在。");
            }
        }
    }
}
