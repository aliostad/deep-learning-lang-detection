using System;
using System.IO;
using System.Threading;
using System.Diagnostics;
using System.Windows.Forms;

namespace ProcessDebugger
{
	class Program : Form
	{
		Program(int ID)
		{
			var process	= Process.GetProcessById(ID);
			process.EnableRaisingEvents	= true;
			process.Exited	+= process_Exited;

			this.Text	= "Process : " + process.Id;
		}

		void process_Exited(object sender,EventArgs e)
		{
			var process	= sender as Process;
			this.Text	= process.Id + " exited : " + process.ExitCode.ToString("X");
		}

		static void Main(string[] args)
		{
			Application.Run(new Program(int.Parse(args[0])));
		}
	}
}
