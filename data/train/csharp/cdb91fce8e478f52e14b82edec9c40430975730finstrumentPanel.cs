using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace midiKeyboarder
{
    public partial class instrumentPanel : UserControl
    {
        public instrumentPanel()
        {
            InitializeComponent();
        }
        public int instrumentID;

        public instrument myInstrument { get { return Form1.instruments[instrumentID]; } }

        public void setInstrument(int id)
        {
            instrumentID = id;
            tbIp.Text = Form1.instruments[instrumentID].ip;
            nudPort.Value = myInstrument.port;
            cbxType.SelectedIndex = (int)Form1.instruments[instrumentID].mytype;


        }
        private void cbPlay_CheckedChanged(object sender, EventArgs e)
        {
            if (cbPlay.Checked)
            {
                myInstrument.local = true;
                myInstrument.initKeyDriver();
                if (cbMboxServer.Checked)
                    myInstrument.setMultiboxDriver();
                    
            }
            else
            {

                myInstrument.stop();
            }
        }

        private void cbRemote_CheckedChanged(object sender, EventArgs e)
        {
            if (cbRemote.Checked)
            {
                myInstrument.local = false;
                try
                {
                    Form1.instruments[instrumentID].connect();
                }
                catch (Exception exc)
                { cbRemote.Checked = false;

                System.Diagnostics.Trace.WriteLine(exc.ToString());
                }
            }
            else
                Form1.instruments[instrumentID].disconnect();
        }

        private void tbIp_TextChanged(object sender, EventArgs e)
        {
            Form1.instruments[instrumentID].ip = tbIp.Text;
        }

        private void nudPort_ValueChanged(object sender, EventArgs e)
        {
            Form1.instruments[instrumentID].port = (int)nudPort.Value;
        }

        private void cbxType_SelectedIndexChanged(object sender, EventArgs e)
        {
            Form1.instruments[instrumentID].mytype = (instrument.instrumentType)cbxType.SelectedIndex;
        }

        private void cbMboxServer_CheckedChanged(object sender, EventArgs e)
        {
            if (((CheckBox)sender).Checked)
            {
                myInstrument.startServer();
            }
            else
                myInstrument.stopServer();
        }

        private void instrumentPanel_Load(object sender, EventArgs e)
        {

        }

    }
}
