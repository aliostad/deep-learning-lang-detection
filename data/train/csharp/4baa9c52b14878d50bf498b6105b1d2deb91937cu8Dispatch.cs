using System;
using System.Collections.Generic;
using System.Text;
using DataModel;
using FluentData;
using IDataAccess;

namespace DataAccess.U8
{
    public class u8Dispatch :u8<Dispatch>
    {
        private Dispatch _dispatch = new Dispatch();
        private List<Dispatch> _dispatchs = new List<Dispatch>();
        //private string whereStr() {
        //    StringBuilder wStr = new StringBuilder();
        //    wStr.Append("");
        //    return wStr.ToString();
        //}
        //private string headSqlCmd() {
        //    sqlcmd = new StringBuilder();
        //    sqlcmd.Append("");
        //    return sqlcmd.ToString();
        //}
        public u8Dispatch() {
        }
        public override List<Dispatch> getList(string whereStr)
        {
            List<Dispatch> r = new List<Dispatch>();
            string cmd = "" + whereStr;
            r = Context.Sql("").QueryMany<Dispatch>();
            return r;
        }

        public override Dispatch getSingle(string code)
        {
            u8DispatchMain u8dm = new u8DispatchMain();
            u8DispatchDetail u8dd = new u8DispatchDetail();
            _dispatch.Main = u8dm.getSingle(code);
            _dispatch.Details = u8dd.getList(new VouchDetail() { Mid = _dispatch.Main.Mid });
            _dispatch.Main.Je = 0;
            if (_dispatch.Details != null && _dispatch.Details.Count > 0)
                foreach (var dd in _dispatch.Details)
                {
                    _dispatch.Main.Je += Convert.ToDecimal(dd.iSum);
                }
            return _dispatch;
        }

        public override List<Dispatch> getList(Dispatch searchKey)
        {
            u8DispatchMain u8dm = new u8DispatchMain();
            u8DispatchDetail u8dd = new u8DispatchDetail();
            _dispatchs = new List<Dispatch>();
            if (searchKey != null) {
                if (searchKey.Main != null)
                {
                    var dms = u8dm.getList(searchKey.Main);
                    foreach (var dm in dms)
                    {
                        if (!_dispatchs.Exists(e => e.Main.vouchCode == dm.vouchCode))
                        {
                            _dispatchs.Add(getSingle(dm.vouchCode));
                        }
                    }
                }
                if (searchKey.Details != null)
                {
                    List<VouchMain> dms;
                    foreach (var kd in searchKey.Details)
                    { dms = u8dm.getList(new VouchMain() { Mid = kd.Mid });
                        foreach (var dm in dms)
                        {
                            if (!_dispatchs.Exists(e => e.Main.vouchCode == dm.vouchCode))
                            {
                                _dispatchs.Add(getSingle(dm.vouchCode));
                            }
                        }
                    }
                }
            }
            return _dispatchs;
        }

        public override void setField(string field, string val, Dispatch searchKey)
        {
            //不提供
        }

        public override void setField(string field, string val, string whereStr)
        {
            //不提供
        }
        public override object getField(string field, Dispatch searchKey)
        {//不提供
            object r = null;
            return r;
        }
    }
}
