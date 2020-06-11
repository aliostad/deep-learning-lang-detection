using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using System.Threading;

namespace ControlInvokeRequired
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        #region InvokeRequired Example

        private void btnProcess_Click(object sender, EventArgs e)
        {
            // call method in Main UI thread.  InvokeRequired = false
            UpdateLabel("Main UI.");

            // call method in 2nd thread.      InvokeRequired = true
            Thread thread = new Thread(new ParameterizedThreadStart(UpdateLabel));
            thread.Start("2nd thread.");
        }

        delegate void UpdateLabelDelegate(string message);

        void UpdateLabel(object message)
        {
            //this====> this.label1
            if (this.InvokeRequired) // now in 2nd thread
            {
                // switch from 2nd thread to Main UI thread and then execute method.
                this.Invoke(new UpdateLabelDelegate(UpdateLabel), message);
                //this.BeginInvoke(new UpdateLabelDelegate(UpdateLabel), message);
                return;
            }

            // in main UI thread
            this.label1.Text = (string)message;
        }

        void UpdateLabel2(object message)
        {
            if (this.InvokeRequired) // now in 2nd thread
            {
                // switch to Main UI thread
                this.BeginInvoke(new MethodInvoker(
                    delegate()
                    {
                        UpdateLabel2(message);
                    }
                    ));

                return;
            }

            // in main UI thread
            this.label1.Text = (string)message;
        }

        #endregion

        private void btnTest_Click(object sender, EventArgs e)
        {
            // kzl
            // main thread = control thread = 1
            //MessageBox.Show("Control thread", Thread.CurrentThread.ManagedThreadId.ToString());

            //TestInvoke();
            //TestBeginInvoke();
            //TestBeginInvokeEndInvoke();

            TestBeginInvokeInvoke();
        }

        private void TestInvoke()
        {// begin Invoke  end
            listBox1.Items.Add("--begin--");
            listBox1.Invoke(new Action(() =>
            {// in main thread
                listBox1.Items.Add("Invoke");
            }));

            Thread.Sleep(1000);
            listBox1.Items.Add("--end--");
        }

        private void TestBeginInvoke()
        {// begin end BeginInvoke
            listBox1.Items.Add("--begin--");
            var bi = listBox1.BeginInvoke(new Action(() =>
            {// in main thread 
                MessageBox.Show("Where?", Thread.CurrentThread.ManagedThreadId.ToString());
                listBox1.Items.Add("BeginInvoke");
            }));
            Thread.Sleep(1000);
            listBox1.Items.Add("--end--");
        }

        private void TestBeginInvokeEndInvoke()
        {// begin BeginInvokeEndInvoke  end
            listBox1.Items.Add("--begin--");
            var bi = listBox1.BeginInvoke(new Action(() =>
            {// in main thread
                Thread.Sleep(1000);
                MessageBox.Show("Where?", Thread.CurrentThread.ManagedThreadId.ToString());
                listBox1.Items.Add("BeginInvokeEndInvoke");
            }));
            listBox1.EndInvoke(bi); // block main thread
            listBox1.Items.Add("--end--");
        }
       
        private void TestBeginInvokeInvoke()
        {// begin BeginInvoke Invoke end
            listBox1.Items.Add("--begin--");
            listBox1.BeginInvoke(new Action(() =>
            {
                Thread.Sleep(1000);
                listBox1.Items.Add("BeginInvoke");
            }));
            listBox1.Invoke(new Action(() =>
            {
                listBox1.Items.Add("Invoke");
            }));
            listBox1.Items.Add("--end--");
        }


    }
}
