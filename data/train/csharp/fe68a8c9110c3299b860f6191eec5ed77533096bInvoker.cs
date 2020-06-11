using System;
using System.Collections.Generic;

using System.Web;
using System.Windows.Forms;
using System.Threading;

/// <summary>
///Invoker 的摘要说明
/// </summary>
public class Invoker
{
    public SaveFileDialog InvokeDialog;
    private Thread InvokeThread;
    private DialogResult InvokeResult;

    public Invoker()
    {
        InvokeDialog = new SaveFileDialog();
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