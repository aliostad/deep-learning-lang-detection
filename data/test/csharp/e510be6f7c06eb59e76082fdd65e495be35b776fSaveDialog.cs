using System;
using System.Threading;
using System.Windows.Forms;

namespace FileTransferClient {

    /// <summary>
    /// Враппер для диалога сохранения (для поддержки многопоточности)
    /// </summary>
    public class SaveDialog {
        public SaveFileDialog InvokeDialog;
        private Thread InvokeThread;
        private DialogResult InvokeResult;

        public SaveDialog(String fileName) {
            InvokeDialog = new SaveFileDialog();
            InvokeDialog.FileName = fileName;
            InvokeThread = new Thread(new ThreadStart(InvokeMethod));
            InvokeThread.SetApartmentState(ApartmentState.STA);
            InvokeResult = DialogResult.None;
        }

        public DialogResult Invoke() {
            InvokeThread.Start();
            InvokeThread.Join();
            return InvokeResult;
        }

        private void InvokeMethod() {
            InvokeResult = InvokeDialog.ShowDialog();
        }
    }
}