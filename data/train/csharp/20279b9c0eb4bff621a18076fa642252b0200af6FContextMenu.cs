using System;
using System.Runtime.InteropServices;
using MO.Core.Window.Api;

namespace MO.Core.Window.Core {

   public class FContextMenu : IDisposable {

      internal IntPtr _handle;

      internal IContextMenu _face;

      protected IntPtr _menuHandle = IntPtr.Zero;

      public FContextMenu() {
      }

      public void Create() {
         if (_menuHandle == IntPtr.Zero) {
            _menuHandle = RUser32.CreatePopupMenu();
            _face.QueryContextMenu(_menuHandle, 0, RWinShell.CMD_FIRST, RWinShell.CMD_LAST, ECmf.NORMAL | ECmf.EXPLORE);
         }
      }

      public void Insert(string text, bool enable) {
         EMft extraFlag = enable ? 0 : EMft.GRAYED;
         RUser32.InsertMenu(_menuHandle, 0, EMft.BYPOSITION | extraFlag, (int)(RWinShell.CMD_LAST + 1), text);
         RUser32.InsertMenu(_menuHandle, 1, EMft.BYPOSITION | EMft.SEPARATOR, 0, "-");
         RUser32.SetMenuDefaultItem(_menuHandle, 0, true);
      }

      public int Popup(IntPtr handle, int x, int y) {
         Create();
         uint cmd = RUser32.TrackPopupMenuEx(_menuHandle, ETrackPopupMenu.RETURNCMD, x, y, handle, IntPtr.Zero);
         _menuHandle = IntPtr.Zero;
         if (cmd >= RWinShell.CMD_FIRST) {
            SCmInvokeCommandInfoEX invoke = new SCmInvokeCommandInfoEX();
            invoke.cbSize = Marshal.SizeOf(typeof(SCmInvokeCommandInfoEX));
            invoke.lpVerb = (IntPtr)(cmd - 1);
            invoke.lpDirectory = string.Empty;
            invoke.fMask = 0;
            invoke.ptInvoke = new SPoint();
            invoke.ptInvoke.x = x;
            invoke.ptInvoke.y = y;
            invoke.nShow = 1;
            _face.InvokeCommand(ref invoke);
         }
         return (int)cmd;
      }

      public void InvokeDefault(int x, int y) {
         Create();
         int defaultCommand = RUser32.GetMenuDefaultItem(_menuHandle, false, 0);
         if (defaultCommand != -1) {
            SCmInvokeCommandInfoEX invoke = new SCmInvokeCommandInfoEX();
            invoke.cbSize = Marshal.SizeOf(typeof(SCmInvokeCommandInfoEX));
            invoke.lpVerb = (IntPtr)(defaultCommand - RWinShell.CMD_FIRST);
            invoke.lpDirectory = string.Empty;
            invoke.fMask = 0;
            invoke.ptInvoke = new SPoint();
            invoke.ptInvoke.x = x;
            invoke.ptInvoke.y = y;
            invoke.nShow = 1;
            _face.InvokeCommand(ref invoke);
         }
      }

      public void Release() {
         if (_menuHandle != IntPtr.Zero) {
            RUser32.DestroyMenu(_menuHandle);
            _menuHandle = IntPtr.Zero;
         }
      }

      #region IDisposable implements

      public void Dispose() {
         Release();
      }

      #endregion
   }

}
