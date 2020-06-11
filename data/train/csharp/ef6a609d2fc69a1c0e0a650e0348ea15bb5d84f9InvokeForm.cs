using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace InvokeFormNS
{
    public partial class InvokeForm : Form
    {
        public InvokeForm()
        {
        }

        public void DoInvoke( Action a)
        {
            if (InvokeRequired)
            {
                try
                {
                    Invoke(a);
                }
                catch (Exception e)
                {
                    System.Diagnostics.Debug.WriteLine(e.ToString());
                }
            }
            else
                a();

        }
    }
}
