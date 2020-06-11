using System;
using System.ComponentModel;
using System.Windows;

namespace MGDF.GamesManager.Controls
{
    public delegate void InvokeDelegate();

    public interface IView
    {
        event EventHandler Shown;
        event CancelEventHandler Closing;
        event EventHandler Closed;

        bool Enabled { get; set; }
        void ShowView(IView parentView);
        void CloseView();
        void Invoke(InvokeDelegate d);
    }

    public static class ControlExtensions
    {
        //allow us to invoke events on the view UI thread
        public static void Invoke(this IView view, InvokeDelegate d)
        {
            view.Invoke(d);
        }
    }
}