using System;
using System.Collections.Generic;
using System.Text;

namespace DukesServer.MVP.View
{
    internal interface IView
    {
        event EventHandler Shown;
        event EventHandler Closed;

        void ShowView(IView parentView);
        void CloseView();
        void Invoke(InvokeDelegate d);
    }

    internal delegate void InvokeDelegate();

    internal static class ControlExtensions
    {
        //allow us to invoke events on the view UI thread
        public static void Invoke(this IView view, InvokeDelegate d)
        {
            view.Invoke(d);
        }
    }
}