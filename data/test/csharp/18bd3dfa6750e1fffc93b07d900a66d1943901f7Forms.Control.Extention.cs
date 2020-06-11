using System.ComponentModel;

namespace System
{

    /*
public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Thread thread = new Thread(new ThreadStart(StartCalculation));
            thread.Start();
        }

        public void StartCalculation()
        {
            button1.SafeInvoke(d => d.Enabled = false);

            for (int i = 0; i <= 100; i++)
            {                
                Thread.Sleep(100);
                string textForLabel = (i) + "%";

                lblProcent.SafeInvoke(d => d.Text = textForLabel);
                progressBar1.SafeInvoke(d => d.Value = i);
                string labelText = lblProcent.SafeInvoke(d => d.Text);
                this.SafeInvoke(d => d.SetText("test", "test1"));
            }
            button1.SafeInvoke(d => d.Enabled = true);
        }

        public void SetText(string test1, string test2)
        {

        }
    }
     */

    public static partial class Extention
    {


        public delegate void InvokeHandler();
        public static void SafeInvoke(this System.Windows.Forms.Control control, InvokeHandler handler)
        {
            if (control.InvokeRequired)
            {
                //control.Invoke(handler);
                control.BeginInvoke(handler);
                return;
            }
            else
            {
                handler();
                return;
            }
        }


        public static TResult SafeInvoke<T, TResult>(this T isi, Func<T, TResult> call) where T : ISynchronizeInvoke
        {
            if (isi.InvokeRequired)
            {
                IAsyncResult result = isi.BeginInvoke(call, new object[] { isi });
                object endResult = isi.EndInvoke(result); return (TResult)endResult;
            }
            else
                return call(isi);
        }

        public static void SafeInvoke<T>(this T isi, Action<T> call) where T : ISynchronizeInvoke
        {
            if (isi.InvokeRequired) isi.BeginInvoke(call, new object[] { isi });
            else
                call(isi);
        }

    }
}
