using System;
using System.Windows;
using System.Windows.Threading;


namespace ProjectMomo.Helpers
{
  /// <summary>
  /// A helper class that will dispactch actions in the appropriate threads if neccesary.
  /// </summary>
  public static class DispatchService
  {
    public static void Invoke(Action action)
    {
      Dispatcher dispatchObject = Application.Current.Dispatcher;
      if (dispatchObject == null || dispatchObject.CheckAccess())
      {
        action();
      }
      else
      {
        dispatchObject.Invoke(action);
      }
    }
  }
}
