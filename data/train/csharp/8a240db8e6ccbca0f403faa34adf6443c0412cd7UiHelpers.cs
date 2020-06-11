using System;
using System.ComponentModel;

namespace SS.FTPDownloader.Objects.Extensions
{
	public static class UiHelpers
	{
		public static TResult SafeInvoke<T, TResult>(this T @this, Func<T, TResult> call) where T : ISynchronizeInvoke
		{
			if (!@this.InvokeRequired) return call(@this);

			var result = @this.BeginInvoke(call, new object[]{@this});

			var endResult = @this.EndInvoke(result);

			return (TResult) endResult;
		}

		public static void SafeInvoke<T>(this T isi, Action<T> call) where T : ISynchronizeInvoke
		{
			if (isi.InvokeRequired)
				isi.BeginInvoke(call, new object[]{isi});

			else call(isi);
		}
	}
}