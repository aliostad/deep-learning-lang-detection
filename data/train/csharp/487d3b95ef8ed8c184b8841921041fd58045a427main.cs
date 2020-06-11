using System;
 
namespace Application{
   class MainClass{
      public static void Main (string[] args){
            Process process = null;
            process = new Process();
            process.Startinfo.FileName = "python";
            process.Startinfo.Arguments = "getID.py";
            process.Startinfo.UseShellExecute = false;
            process.Startinfo.ReadirectStandardOutput = true;
            process.OutputDataReceived += p_OutputDataReceived;

            process.Start();

            process.BeginOutputReadLine();
            process.WaitForExit();

        }
   }
}
