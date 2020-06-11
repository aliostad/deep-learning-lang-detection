namespace King.Framework.Plugin.Aop
{
    using King.Framework.Plugin.Web;
    using System;

    [AttributeUsage(AttributeTargets.Method, AllowMultiple=false, Inherited=false)]
    public class CommandPluginAttribute : Attribute
    {
        private readonly King.Framework.Plugin.Web.InvokeType _invokeType;
        private readonly string _key;

        public CommandPluginAttribute(string key, King.Framework.Plugin.Web.InvokeType invokeType)
        {
            this._key = key;
            this._invokeType = invokeType;
        }

        public string ButtonName
        {
            get
            {
                return this._key;
            }
        }

        public King.Framework.Plugin.Web.InvokeType InvokeType
        {
            get
            {
                return this._invokeType;
            }
        }
    }
}

