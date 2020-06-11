using System;
using System.Windows.Forms;
using Chiffrage.Mvc.Exceptions;

namespace Chiffrage.Mvc.Views
{
    public class UserControlView : WithValidationUserControl, IView
    {
        #region IView Members

        public virtual void SetParent(IWin32Window parent)
        {
            Parent = parent as Control;
            Dock = DockStyle.Fill;
        }

        public virtual void ShowView()
        {
            if(this.Parent == null)
            {
                throw new NoParentViewException();
            }
            else
            {
                InvokeIfRequired(Show);   
            }            
        }

        public virtual void HideView()
        {
            InvokeIfRequired(Hide);
        }

        #endregion

        public void InvokeIfRequired(Action action)
        {
            if (this.InvokeRequired)
            {
                BeginInvoke(action);
            }
            else
            {
                action();   
            }            
        }

        public T InvokeIfRequired<T>(Func<T> func)
        {
            if (this.InvokeRequired)
            {
                var asyncResult = BeginInvoke(func);
                return (T)EndInvoke(asyncResult);
            }
            else
            {
                return func();
            }
        }
    }
}