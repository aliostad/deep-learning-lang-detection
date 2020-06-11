using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

namespace VS2017YukleMatik.dll
{
  public  class Komut
    {
       public static void KomutCalistir(string Komut)
        {
            
            Process Process = new Process();
            ProcessStartInfo ProcessInfo;
            ProcessInfo = new ProcessStartInfo("cmd.exe", "/C "+@Komut);
            ProcessInfo.CreateNoWindow = true;
            ProcessInfo.UseShellExecute = false;

            Process = Process.Start(ProcessInfo);
            Process.WaitForExit();
            Process.Close();
        }
    }
}
