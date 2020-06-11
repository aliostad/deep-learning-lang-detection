using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using ProWrite.UI.Controls.Common;
using ProWrite.UI.Controls.Common.Messages;
using log4net;

namespace ProWrite.UI.Controls.Actions
{
    public interface IRequestAction
    {
        void Perform();
    }

    public abstract class RequestActionBase:IRequestAction,ISynchronizeInvoke
    {
        protected static ILog log = LogManager.GetLogger("RequestAction");
        public abstract void Perform();

        private  ISynchronizeInvoke HWND
        {
            get
            {
                return FormHelper.ActiveForm;
            }
        }

        #region ISynchronizeInvoke Members

        IAsyncResult ISynchronizeInvoke.BeginInvoke(Delegate method, object[] args)
        {
            if (HWND != null)
                return HWND.BeginInvoke(method, args);
            return null;
        }

        object ISynchronizeInvoke.EndInvoke(IAsyncResult result)
        {
            if (HWND != null)
                return HWND.EndInvoke(result);
            return null;
        }

        object ISynchronizeInvoke.Invoke(Delegate method, object[] args)
        {
            if (HWND != null)
                return HWND.Invoke(method, args);
            return null;
        }

        bool ISynchronizeInvoke.InvokeRequired
        {
            get { return HWND != null && HWND.InvokeRequired; }
        }

        #endregion
    }
}
