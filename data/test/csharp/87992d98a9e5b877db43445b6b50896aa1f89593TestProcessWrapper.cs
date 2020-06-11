using System;
using System.Diagnostics;

namespace Windowmancer.Tests.Models
{
  public class TestProcessWrapper : IDisposable
  {
    public Process Process { get; }

    public int Id => this.Process.Id;

    public string MainWindowTitle => this.Process.MainWindowTitle;

    public IntPtr MainWindowHandle => this.Process.MainWindowHandle;

    public TestProcessWrapper(Process process)
    {
      this.Process = process;
    }

    public void Dispose()
    {
      if (this.Process.HasExited) return;
      this.Process.Kill();
    }

    public void Kill()
    {
      this.Process.Kill();
    }
  }
}
