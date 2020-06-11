using System;
using System.ComponentModel;

namespace RatCow.Utilities
{
  /// <summary>
  /// Useful class taken from this article:
  /// http://stackoverflow.com/a/711419
  /// </summary>
  public static class ISynchronizeInvokeExtensions
  {
    public static void InvokeEx<T>( this T @this, Action<T> action ) where T : ISynchronizeInvoke
    {
      if ( @this.InvokeRequired )
      {
        @this.Invoke( action, new object[] { @this } );
      }
      else
      {
        action( @this );
      }
    }
  }
}