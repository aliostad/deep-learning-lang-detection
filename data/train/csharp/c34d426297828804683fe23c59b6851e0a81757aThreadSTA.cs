using System.Threading;
using System.Windows.Forms;

namespace Contact.App.Base
{
    public class ThreadSTA
    {
        public OpenFileDialog InvokeOpenDialog;
        public SaveFileDialog InvokeSaveDialog;
        private Thread InvokeThread;
        private DialogResult InvokeResult;
        
        public ThreadSTA(OpenFileDialog openFileDialog)
        {
            InvokeOpenDialog = openFileDialog;
            InvokeThread = new Thread(new ThreadStart(InvokeOpenMethod));
            InvokeThread.SetApartmentState(ApartmentState.STA);
            InvokeResult = DialogResult.None;
        }

        public ThreadSTA(SaveFileDialog saveFileDialog)
        {
            InvokeSaveDialog = saveFileDialog;
            InvokeThread = new Thread(new ThreadStart(InvokeSaveMethod));
            InvokeThread.SetApartmentState(ApartmentState.STA);
            InvokeResult = DialogResult.None;
        }

        public DialogResult Invoke()
        {
            InvokeThread.Start();
            InvokeThread.Join();
            return InvokeResult;
        }

        private void InvokeOpenMethod()
        {
            InvokeResult = InvokeOpenDialog.ShowDialog();
        }

        private void InvokeSaveMethod()
        {
            InvokeResult = InvokeSaveDialog.ShowDialog();
        }
    }
}