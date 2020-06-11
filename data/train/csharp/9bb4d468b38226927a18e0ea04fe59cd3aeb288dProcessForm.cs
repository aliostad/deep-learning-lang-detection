using System;
using System.Windows.Forms;
using kidd.software.dotnet.fotocompressor.library.processes;

namespace kidd.software.dotnet.fotocompressor
{
    public partial class ProcessForm : Form
    {
        private BaseProcess _process;
        public ProcessForm(BaseProcess baseProcess)
        {
            InitializeComponent();
            _process = baseProcess;

        }


        private void btnOk_Click(object sender, EventArgs e)
        {
            _process.Start();
            tbProcessStatus.Text = _process.Status.ToString();

            while (_process.Status == ProcessStatus.started)
            {
                progressBar.Value = _process.ProgressPercentage;
                tbProcessStatus.Text = _process.Status.ToString();
                if (_process.Status == ProcessStatus.finished)
                {
                    break;
                }
            }
            tbProcessStatus.Text = _process.Status.ToString();
        }
    }
}
