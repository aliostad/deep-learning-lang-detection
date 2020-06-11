using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Expression.Interactivity.Core;
using System.Diagnostics;

namespace WPFLib.Behaviors
{
    /// <summary>
    /// Решает багу, когда действие запускают до того как возникло OnTargetChanged(при загрузке например)
    /// </summary>
    public class GoToStateActionFixed : GoToStateAction
    {
        bool needInvoke = false;
        bool isAttached = false;
        object invokeParameter;

        protected override void OnAttached()
        {
            isAttached = true;
            base.OnAttached();
            this.OnTargetChanged(null, null);
            if (needInvoke)
            {
                this.Dispatcher.BeginInvoke((Action)this.InvokeOnAttached, System.Windows.Threading.DispatcherPriority.Background);
            }
        }

        private void InvokeOnAttached()
        {
            this.Invoke(invokeParameter);
            invokeParameter = null;
        }

        protected override void Invoke(object parameter)
        {
            if (!isAttached)
            {
                invokeParameter = parameter;
                needInvoke = true;
                return;
            }
            //Debug.WriteLine("GoToState object " + this.Target.GetHashCode() + " " + parameter);
            base.Invoke(parameter);
        }
    }
}
