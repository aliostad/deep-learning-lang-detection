using System.Threading;
using System.Windows.Forms;

namespace Client
{
    public class Invoker
    {
        public SaveFileDialog InvokeDialog;
        private Thread _invokeThread;
        private DialogResult _invokeResult;

        public Invoker(SaveFileDialog dialog)
        {
            InvokeDialog = dialog;
            _invokeThread = new Thread(new ThreadStart(InvokeMethod));
            _invokeThread.SetApartmentState(ApartmentState.STA);
            _invokeResult = DialogResult.None;
        }

        public DialogResult Invoke()
        {
            _invokeThread.Start();
            _invokeThread.Join();
            return _invokeResult;
        }

        private void InvokeMethod()
        {
            _invokeResult = InvokeDialog.ShowDialog();

        }
    }
}