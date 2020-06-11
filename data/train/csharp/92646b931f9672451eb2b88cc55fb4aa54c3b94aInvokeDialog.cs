using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading;

namespace KuaFu.Helper
{
    public class Invoker
    {
        public OpenFileDialog InvokeDialog;
        private Thread InvokeThread;
        private DialogResult InvokeResult;

        public Invoker()
        {
            InvokeDialog = new OpenFileDialog();
            InvokeDialog.Filter = "ESRI Shapefile|*.shp";
            InvokeThread = new Thread(new ThreadStart(InvokeMethod));
            InvokeThread.SetApartmentState(ApartmentState.STA);
            InvokeResult = DialogResult.None;
        }

        public DialogResult Invoke()
        {
            InvokeThread.Start();
            InvokeThread.Join();
            return InvokeResult;
        }

        private void InvokeMethod()
        {
            InvokeResult = InvokeDialog.ShowDialog();
        }
    }
}
