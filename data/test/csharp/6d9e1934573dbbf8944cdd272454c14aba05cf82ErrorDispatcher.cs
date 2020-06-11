using System;
using System.IO;

namespace HappyShop.ServiceConnector
{
  public class ErrorDispatcher
  {
    public ErrorDispatcher(string errorDispatchTarget)
    {
      switch(errorDispatchTarget.Trim().ToLowerInvariant())
      {
        case "mail":
          _dispatchTarget = ErrorDispatchTarget.Email;
          break;
        case "file":
          _dispatchTarget = ErrorDispatchTarget.File;
          break;
        case "console":
          _dispatchTarget = ErrorDispatchTarget.Console;
          break;
        default:
          _dispatchTarget = ErrorDispatchTarget.None;
          break;
      }
    }

    public ErrorDispatcher AddRecipients(string recipients)
    {
      return this;
    }

    public ErrorDispatcher AddSubject(string subject)
    {
      return this;
    }

    public ErrorDispatcher AddMessage(string message)
    {
      _message = message;
      return this;
    }

    public void Dispatch()
    {
      switch(_dispatchTarget)
      {
        case ErrorDispatchTarget.Console:
          Console.WriteLine(_message);
          break;
        case ErrorDispatchTarget.File:
          File.WriteAllText("langweilig_.txt".AppendTimeStamp(), _message);
          break;
      }
    }

    private string _message = string.Empty;
    private string _recipents = string.Empty;
    private string _subject = string.Empty;
    private ErrorDispatchTarget _dispatchTarget;
  }

  public enum ErrorDispatchTarget
  {
    None,
    Email,
    File,
    Console
  }
}
