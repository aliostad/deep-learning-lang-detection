using System;
using System.Windows.Media.Imaging;

namespace Topifier.Structs
{
    /// <summary>
    /// The my process.
    /// </summary>
    public struct MyProcess
    {
        public MyProcess(string processWindowTitle, IntPtr mainWindowHandle, BitmapImage processIcon)
            : this()
        {
            ProcessWindowTitle = processWindowTitle;
            ProcessHandle = mainWindowHandle;
            ProcessIcon = processIcon;
        }

        public override string ToString()
        {
            return ProcessWindowTitle;
        }

        public BitmapImage ProcessIcon { get; set; }
        public IntPtr ProcessHandle { get; set; }
        public string ProcessWindowTitle { get; set; }
    }
}