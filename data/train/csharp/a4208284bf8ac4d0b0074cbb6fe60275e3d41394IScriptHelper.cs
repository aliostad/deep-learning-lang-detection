using System;
using System.Management.Automation;
using System.Reflection;
using VMLab.Model;

namespace VMLab.Helper
{
    public interface IScriptHelper
    {
        object Invoke(ScriptBlock script);
        object Invoke(ScriptBlock script, object properties);
    }

    public class ScriptHelper : IScriptHelper
    {
        public object Invoke(ScriptBlock script)
        {
            return script.Invoke();
        }

        public object Invoke(ScriptBlock script, object properties)
        {
            return script.Invoke(properties);
        }
    }
}
