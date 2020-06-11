using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PRSP_1Ejemplo
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            Process[] procesos = Process.GetProcesses();
            foreach (Process item in procesos)
            {
                listBoxProcesos.Items.Add(item.ProcessName);
            }

            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Process notepadProcess = new Process();
            string processName = "Notepad";
            notepadProcess.StartInfo.FileName = processName;
            notepadProcess.StartInfo.WindowStyle = ProcessWindowStyle.Maximized;

            if (Process.GetProcessesByName(notepadProcess.ProcessName).Length > 0)
                notepadProcess.Start();
            else
                notepadProcess.Kill();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Process wordProcess = new Process();
            //string processName = @"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2013\Word 2013";
            string processName = "WinWord";
            if (!processIsOpen(processName))
            {
                wordProcess.StartInfo.FileName = processName;
                wordProcess.StartInfo.WindowStyle = ProcessWindowStyle.Minimized;
                wordProcess.Start();
            }
            else
                wordProcess.Kill();
        }


        private bool processIsOpen(string processName)
        {
            Process[] procesos = Process.GetProcesses();
            foreach (Process item in procesos)
                if (item.ProcessName == processName)
                    return true;
            return false;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            string processName = "chrome";
            Process[] procesos = Process.GetProcesses();
            foreach (Process item in procesos)
                if (item.ProcessName == processName)
                    item.Kill();

        }
}
