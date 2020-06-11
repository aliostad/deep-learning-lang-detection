using System;
using JetBrains.ReSharper.Daemon;

namespace JetBrains.ReSharper.PsiPlugin.CodeInspections.Psi
{
  public class SmartResolverProcess : IDaemonStageProcess
  {
    private readonly IDaemonProcess myDaemonProcess;

    public SmartResolverProcess(IDaemonProcess daemonProcess)
    {
      myDaemonProcess = daemonProcess;
    }

    #region IDaemonStageProcess Members

    public IDaemonProcess DaemonProcess
    {
      get { return myDaemonProcess; }
    }

    public void Execute(Action<DaemonStageResult> commiter)
    {
    }

    #endregion
  }
}
