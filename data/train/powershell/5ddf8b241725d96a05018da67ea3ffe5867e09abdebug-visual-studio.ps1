Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class SFW {
     [DllImport("user32.dll")]
     [return: MarshalAs(UnmanagedType.Bool)]
     public static extern bool SetForegroundWindow(IntPtr hWnd);
  }
"@

# load assembly containing class System.Windows.Forms.SendKeys
[void] [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#Add-Type -AssemblyName System.Windows.Forms


$h =  (get-process devenv).MainWindowHandle # just one notepad must be opened!
[SFW]::SetForegroundWindow($h)
[System.Windows.Forms.SendKeys]::SendWait("{F5}")