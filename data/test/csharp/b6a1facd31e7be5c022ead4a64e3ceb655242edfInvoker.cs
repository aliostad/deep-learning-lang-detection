using System.Threading;
using System.Windows.Forms;

namespace SampleFutronicScanDemo.Common
{
    public class Invoker
    {
        public CommonDialog InvokeDialog;
        private Thread InvokeThread;
        private DialogResult InvokeResult;

        public Invoker(CommonDialog dialog)
        {
            InvokeDialog = dialog;
            InvokeThread = new Thread(InvokeMethod);
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
